import { Worker, Job } from "bullmq"
import { DarajaClient } from "./daraja.client"
import { MpesaService } from "./mpesa.service"
import { RiskService } from "./risk.service"
import { MpesaModuleOptions, CallbackJobData, DarajaCallbackBody } from "./types"
import { getRedisConnection, isProcessed } from "./queue"

// ─────────────────────────────────────────────
//  Callback Worker – BullMQ job processor
//  Runs as a separate process from the API
// ─────────────────────────────────────────────
export function startCallbackWorker(opts: MpesaModuleOptions): Worker {
    const connection = getRedisConnection(opts.redisUrl)
    const daraja = new DarajaClient(opts)
    const mpesaService = new MpesaService(daraja, opts)
    const riskService = new RiskService(opts.redisUrl)

    const worker = new Worker<CallbackJobData>(
        "mpesa-callback",
        async (job: Job<CallbackJobData>) => {
            await processCallback(job.data, mpesaService, riskService, opts)
        },
        {
            connection,
            concurrency: 5,             // Process up to 5 callbacks simultaneously
        }
    )

    worker.on("completed", (job) => {
        console.log(`[MPESA WORKER] Job ${job.id} completed`)
    })

    worker.on("failed", (job, err) => {
        console.error(`[MPESA WORKER] Job ${job?.id} failed:`, err.message)
    })

    return worker
}

// ── Core processing logic ─────────────────────
async function processCallback(
    jobData: CallbackJobData,
    mpesaService: MpesaService,
    riskService: RiskService,
    opts: MpesaModuleOptions
): Promise<void> {
    const { payload, payloadHash } = jobData
    const stkCallback = payload.Body?.stkCallback

    if (!stkCallback) {
        console.error("[MPESA WORKER] Invalid callback payload structure")
        return
    }

    // 1. Final idempotency check (race condition safety via Redis)
    const redis = getRedisConnection(opts.redisUrl)
    const alreadyProcessed = await isProcessed(redis, payloadHash)
    if (alreadyProcessed) {
        console.log(`[MPESA WORKER] Duplicate callback, skipping: ${payloadHash}`)
        return
    }

    // 2. Find session via CheckoutRequestID
    const tx = mpesaService.findByCheckoutRequestId(stkCallback.CheckoutRequestID)

    // 3. Handle non-success result codes
    if (stkCallback.ResultCode !== 0) {
        console.log(
            `[MPESA WORKER] STK rejected by user or expired. Code=${stkCallback.ResultCode} Desc=${stkCallback.ResultDesc}`
        )
        if (tx) {
            const updated = await mpesaService.confirmFromCallback(payload, 0, [])
            console.log(`[MPESA WORKER] Marked tx ${updated?.id} as FAILED`)
        }
        return
    }

    // 4. Risk scoring
    const riskResult = await riskService.score({
        transaction: tx ?? null,
        callback: payload,
        sessionPhone: tx?.phoneNumber ?? "",
        sessionAmount: tx?.amount ?? 0,
    })

    console.log(
        `[MPESA WORKER] Risk score=${riskResult.score} action=${riskResult.action} flags=${riskResult.flags.join(",")}`
    )

    // 5. Confirm in DB
    const updated = await mpesaService.confirmFromCallback(
        payload,
        riskResult.score,
        riskResult.flags
    )

    if (!updated) {
        console.error(`[MPESA WORKER] Could not find transaction for CheckoutRequestID ${stkCallback.CheckoutRequestID}`)
        return
    }

    // 6. Act on risk decision
    if (riskResult.action === "block") {
        console.error(`[MPESA WORKER][FRAUD] Transaction ${updated.id} BLOCKED. Flags: ${riskResult.flags.join(", ")}`)
        await notifyAdmin(
            opts,
            `🚨 FRAUD BLOCK: Transaction ${updated.id} blocked. Score=${riskResult.score} Flags=${riskResult.flags.join(", ")}`
        )
        return
    }

    if (riskResult.action === "review") {
        console.warn(`[MPESA WORKER][REVIEW] Transaction ${updated.id} flagged for review. Score=${riskResult.score}`)
        await notifyAdmin(
            opts,
            `⚠️ REVIEW REQUIRED: Transaction ${updated.id}. Score=${riskResult.score} Flags=${riskResult.flags.join(", ")}`
        )
        return
    }

    // 7. Auto-approve: capture + finalize order
    await mpesaService.capture(updated.id)
    console.log(`[MPESA WORKER] ✅ Payment captured for tx ${updated.id} orderId=${updated.orderId}`)

    // TODO: Integrate with Medusa order completion
    // await medusaContainer.resolve(IPaymentModuleService).capturePayment(...)
}

// ── Admin notification ────────────────────────
async function notifyAdmin(opts: MpesaModuleOptions, message: string): Promise<void> {
    if (opts.slackWebhookUrl) {
        try {
            const { default: axios } = await import("axios")
            await axios.post(opts.slackWebhookUrl, { text: message })
        } catch {
            console.error("[MPESA WORKER] Slack notification failed")
        }
    }
    console.error(`[ADMIN ALERT] ${message}`)
}
