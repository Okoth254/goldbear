import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { DarajaClient } from "../../../../modules/mpesa/daraja.client"
import { MpesaService } from "../../../../modules/mpesa/mpesa.service"
import { MpesaModuleOptions } from "../../../../modules/mpesa/types"

function getMpesaOpts(): MpesaModuleOptions {
    return {
        consumerKey: process.env.MPESA_CONSUMER_KEY!,
        consumerSecret: process.env.MPESA_CONSUMER_SECRET!,
        shortcode: process.env.MPESA_SHORTCODE!,
        passkey: process.env.MPESA_PASSKEY!,
        initiatorName: process.env.MPESA_INITIATOR_NAME!,
        securityCredential: process.env.MPESA_SECURITY_CREDENTIAL!,
        callbackBaseUrl: process.env.MPESA_CALLBACK_BASE_URL!,
        environment: (process.env.MPESA_ENV as "sandbox" | "production") ?? "sandbox",
        redisUrl: process.env.REDIS_URL!,
        slackWebhookUrl: process.env.SLACK_WEBHOOK_URL,
    }
}

/**
 * GET /admin/mpesa/reconciliation-logs
 * Lists reconciliation run logs (admin only).
 */
export async function GET(req: MedusaRequest, res: MedusaResponse) {
    const opts = getMpesaOpts()
    const daraja = new DarajaClient(opts)
    const service = new MpesaService(daraja, opts)
    const logs = service.getReconciliationLogs()

    res.json({ logs, count: logs.length })
}
