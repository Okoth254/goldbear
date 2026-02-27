import { useQuery, useMutation } from "@tanstack/react-query"
import { sdk } from "../lib/sdk"

// --- Types ---
export type MpesaTransaction = {
    id: string
    orderId: string
    phoneNumber: string
    merchantRequestId: string
    checkoutRequestId: string
    mpesaReceipt: string | null
    amount: number
    currency: string
    status: "pending" | "authorized" | "captured" | "failed" | "reversed" | "under_review" | "expired" | "cancelled"
    riskScore: number
    createdAt: string
    updatedAt: string
}

export type ReconciliationLog = {
    id: string
    transaction: MpesaTransaction
    darajaStatus: string
    internalStatus: string
    actionTaken: string
    timestamp: string
}

// --- Hooks ---

/**
 * Fetch all M-Pesa transactions.
 */
export const useMpesaTransactions = () => {
    return useQuery({
        queryFn: () => sdk.client.fetch(`/admin/mpesa/transactions`, { method: "GET" }),
        queryKey: ["mpesa_transactions"],
    })
}

/**
 * Fetch all reconciliation logs.
 */
export const useReconciliationLogs = () => {
    return useQuery({
        queryFn: () => sdk.client.fetch(`/admin/mpesa/reconciliation-logs`, { method: "GET" }),
        queryKey: ["mpesa_reconciliation_logs"],
    })
}

/**
 * Initiate a transaction reversal.
 */
export const useReverseMpesaTransaction = (transactionId: string) => {
    return useMutation({
        mutationFn: (data: { reason: string }) =>
            sdk.client.fetch(`/admin/mpesa/transactions/${transactionId}/reverse`, {
                method: "POST",
                body: data,
            }),
    })
}
