import { DarajaClient } from "./daraja.client"
import {
    MpesaStatus,
    MpesaModuleOptions,
    MpesaTransactionRecord,
    ReconciliationLogRecord,
    AuditLogRecord,
    DarajaCallbackBody,
} from "./types"
import {
    generateId,
    extractMetaValue,
    nowEAT,
} from "./utils"

// ─────────────────────────────────────────────
//  In-memory store (dev / prototype)
//  → Replace with MikroORM repository in prod
// ─────────────────────────────────────────────
const txStore = new Map<string, MpesaTransactionRecord>()
const reconLogs: ReconciliationLogRecord[] = []
const auditLogs: AuditLogRecord[] = []

// ─────────────────────────────────────────────
//  MpesaService – Business Logic Layer
// ─────────────────────────────────────────────
export class MpesaService {
    private daraja: DarajaClient
    private opts: MpesaModuleOptions

    constructor(daraja: DarajaClient, opts: MpesaModuleOptions) {
        this.daraja = daraja
        this.opts = opts
    }

    // ── Initiate STK Push (idempotent) ───────────
    async initiateSTKPush(params: {
        orderId: string
        customerId?: string
        phone: string
        amount: number
        reference: string
    }): Promise<MpesaTransactionRecord> {
        // Idempotency: return existing pending transaction for same order
        const existing = this.findByOrderId(params.orderId)
        if (existing && existing.status === MpesaStatus.PENDING) {
            return existing
        }

        const stkResp = await this.daraja.initiateSTKPush({
            amount: params.amount,
            phone: params.phone,
            reference: params.reference,
        })

        const tx: MpesaTransactionRecord = {
            id: generateId(),
            orderId: params.orderId,
            customerId: params.customerId,
            phoneNumber: params.phone,
            merchantRequestId: stkResp.MerchantRequestID,
            checkoutRequestId: stkResp.CheckoutRequestID,
            amount: params.amount,
            currency: "KES",
            status: MpesaStatus.PENDING,
            riskScore: 0,
            riskFlags: [],
            createdAt: nowEAT(),
            updatedAt: nowEAT(),
        }

        txStore.set(tx.id, tx)
        return tx
    }

    // ── Confirm Payment from Callback ─────────────
    async confirmFromCallback(
        callback: DarajaCallbackBody,
        riskScore: number,
        riskFlags: string[]
    ): Promise<MpesaTransactionRecord | null> {
        const stk = callback.Body.stkCallback
        const items = stk.CallbackMetadata?.Item ?? []
        const receipt = String(extractMetaValue(items, "MpesaReceiptNumber") ?? "")

        const tx = this.findByCheckoutRequestId(stk.CheckoutRequestID)
        if (!tx) return null

        // Successful payment (ResultCode 0)
        if (stk.ResultCode === 0) {
            tx.status = riskScore > 50
                ? MpesaStatus.UNDER_REVIEW
                : MpesaStatus.AUTHORIZED
            tx.mpesaReceipt = receipt
            tx.riskScore = riskScore
            tx.riskFlags = riskFlags
            tx.rawCallbackPayload = callback as unknown as Record<string, unknown>
            tx.updatedAt = nowEAT()
        } else {
            tx.status = MpesaStatus.FAILED
            tx.updatedAt = nowEAT()
        }

        txStore.set(tx.id, tx)
        return tx
    }

    // ── Capture (mark fully captured) ────────────
    async capture(transactionId: string): Promise<MpesaTransactionRecord | null> {
        const tx = txStore.get(transactionId)
        if (!tx) return null
        tx.status = MpesaStatus.CAPTURED
        tx.updatedAt = nowEAT()
        txStore.set(tx.id, tx)
        return tx
    }

    // ── Reverse Transaction ──────────────────────
    async reverseTransaction(params: {
        transactionId: string
        adminId: string
        reason: string
    }): Promise<void> {
        const tx = txStore.get(params.transactionId)
        if (!tx || !tx.mpesaReceipt) {
            throw new Error(`Transaction ${params.transactionId} not found or has no receipt`)
        }

        await this.daraja.reverseTransaction({
            transactionId: tx.mpesaReceipt,
            amount: tx.amount,
            reason: params.reason,
            receiverParty: tx.phoneNumber,
        })

        tx.status = MpesaStatus.REVERSED
        tx.updatedAt = nowEAT()
        txStore.set(tx.id, tx)

        // Write audit log
        const log: AuditLogRecord = {
            id: generateId(),
            adminId: params.adminId,
            action: "REVERSAL",
            transactionId: params.transactionId,
            reason: params.reason,
            createdAt: nowEAT(),
        }
        auditLogs.push(log)
    }

    // ── Getters ───────────────────────────────────
    findByCheckoutRequestId(checkoutRequestId: string): MpesaTransactionRecord | undefined {
        return [...txStore.values()].find(
            (tx) => tx.checkoutRequestId === checkoutRequestId
        )
    }

    findByMpesaReceipt(receipt: string): MpesaTransactionRecord | undefined {
        return [...txStore.values()].find((tx) => tx.mpesaReceipt === receipt)
    }

    findByOrderId(orderId: string): MpesaTransactionRecord | undefined {
        return [...txStore.values()].find((tx) => tx.orderId === orderId)
    }

    findPendingOlderThan(minutes: number): MpesaTransactionRecord[] {
        const cutoff = new Date(Date.now() - minutes * 60 * 1000)
        return [...txStore.values()].filter(
            (tx) => tx.status === MpesaStatus.PENDING && tx.createdAt < cutoff
        )
    }

    getTransaction(id: string): MpesaTransactionRecord | undefined {
        return txStore.get(id)
    }

    listTransactions(): MpesaTransactionRecord[] {
        return [...txStore.values()].sort(
            (a, b) => b.createdAt.getTime() - a.createdAt.getTime()
        )
    }

    // ── Reconciliation helpers ────────────────────
    addReconciliationLog(log: Omit<ReconciliationLogRecord, "id" | "reconciledAt">): void {
        reconLogs.push({ ...log, id: generateId(), reconciledAt: nowEAT() })
    }

    getReconciliationLogs(): ReconciliationLogRecord[] {
        return reconLogs
    }

    getAuditLogs(): AuditLogRecord[] {
        return auditLogs
    }
}
