import { defineWidgetConfig } from "@medusajs/admin-sdk"
import { Container, Heading, Text, Badge, Button, Prompt, usePrompt } from "@medusajs/ui"
import { useQuery } from "@tanstack/react-query"
import { useReverseMpesaTransaction, MpesaTransaction } from "../hooks/api"
import { sdk } from "../lib/sdk"
import { useState } from "react"

type OrderWidgetProps = {
    data: {
        id: string
        payment_collections?: Array<{
            payment_providers?: Array<{ id: string }>
            payments?: Array<{ provider_id: string }>
        }>
    }
}

// Ensure widget only renders if there's a payment collection involving mpesa
const isMpesaOrder = (props: OrderWidgetProps) => {
    return props.data.payment_collections?.some(pc =>
        pc.payment_providers?.some(prov => prov.id === "mpesa") ||
        pc.payments?.some(pay => pay.provider_id === "mpesa")
    ) ?? false
}

// We fetch the custom mpesa_transaction associated directly with this order_id
const fetchTransactionByOrderId = async (orderId: string) => {
    const { transactions } = await sdk.client.fetch<{ transactions: MpesaTransaction[] }>(`/admin/mpesa/transactions`, {
        method: "GET",
    })
    return transactions.find(t => t.orderId === orderId) || null
}

const MpesaOrderWidget = (props: OrderWidgetProps) => {
    // Return null immediately if not an M-Pesa order so the UI is clean
    if (!isMpesaOrder(props)) {
        return null
    }

    const dialog = usePrompt()
    const [isReversing, setIsReversing] = useState(false)
    const [reason, setReason] = useState("")

    const { data: tx, isLoading, refetch } = useQuery({
        queryFn: () => fetchTransactionByOrderId(props.data.id),
        queryKey: ["mpesa_tx_for_order", props.data.id],
    })

    // Prepare reversal mutation hook
    const transactionId = tx?.id || "unknown"
    const reverseMutation = useReverseMpesaTransaction(transactionId)

    const handleReverseClick = async () => {
        const confirmed = await dialog({
            title: "Initiate M-Pesa Reversal",
            description: "Note: You must be a Finance Admin. This action will contact Safaricom Daraja immediately. Reversals can take 48 hours to complete on Safaricom's end.",
            confirmText: "Yes, Reverse",
            cancelText: "Cancel",
        })

        if (!confirmed) return

        if (reason.trim().length < 5) {
            alert("A reason of at least 5 characters is required.")
            return
        }

        setIsReversing(true)
        reverseMutation.mutate({ reason }, {
            onSuccess: () => {
                alert("Reversal initiated successfully!")
                refetch()
                setIsReversing(false)
            },
            onError: (err: any) => {
                alert(`Failed to reverse: ${err.message || 'Unknown error'}`)
                setIsReversing(false)
            }
        })
    }

    if (isLoading) return null
    if (!tx) return (
        <Container className="p-6 mb-4">
            <Heading level="h2">M-Pesa Payment Info</Heading>
            <Text className="text-ui-fg-subtle mt-2">Could not locate detailed transaction logs for this order.</Text>
        </Container>
    )

    const isFlagged = tx.riskScore >= 21
    const canReverse = tx.status === "captured" && tx.mpesaReceipt

    return (
        <Container className="p-6 mb-4 flex flex-col gap-y-4">
            <div className="flex items-center justify-between">
                <Heading level="h2">M-Pesa Payment Details</Heading>
                {isFlagged && (
                    <Badge color="orange">Flagged for Review</Badge>
                )}
            </div>

            <div className="grid grid-cols-2 gap-4 mt-2">
                <div>
                    <Text className="text-ui-fg-subtle text-small">M-Pesa Receipt</Text>
                    <Text className="font-mono">{tx.mpesaReceipt || 'N/A'}</Text>
                </div>
                <div>
                    <Text className="text-ui-fg-subtle text-small">Phone Number</Text>
                    <Text>{tx.phoneNumber}</Text>
                </div>
                <div>
                    <Text className="text-ui-fg-subtle text-small">Risk Score</Text>
                    <Text className={isFlagged ? "text-ui-fg-error font-medium" : ""}>{tx.riskScore}</Text>
                </div>
                <div>
                    <Text className="text-ui-fg-subtle text-small">Status</Text>
                    <Badge color={tx.status === 'captured' ? 'green' : tx.status === 'reversed' ? 'purple' : 'grey'}>
                        {tx.status}
                    </Badge>
                </div>
            </div>

            {canReverse && (
                <div className="mt-4 pt-4 border-t border-ui-border-base">
                    <Text className="text-ui-fg-subtle text-small mb-2">Reversal Reason</Text>
                    <input
                        type="text"
                        className="w-full px-3 py-2 border rounded-md mb-2 bg-ui-bg-field"
                        placeholder="E.g., Customer requested refund..."
                        value={reason}
                        onChange={(e) => setReason(e.target.value)}
                    />
                    <Button
                        variant="danger"
                        onClick={handleReverseClick}
                        isLoading={isReversing}
                    >
                        Initiate B2C Reversal
                    </Button>
                </div>
            )}
        </Container>
    )
}

// Inject above the first section on the order details screen
export const config = defineWidgetConfig({
    zone: "order.details.before",
})

export default MpesaOrderWidget
