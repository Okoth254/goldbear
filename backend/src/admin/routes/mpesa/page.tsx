import { Container, Heading, Table, Badge, Text } from "@medusajs/ui"
import { useQuery } from "@tanstack/react-query"
import { sdk } from "../../lib/sdk"

export type MpesaTransaction = {
    id: string
    orderId: string
    phoneNumber: string
    merchantRequestId: string
    checkoutRequestId: string
    mpesaReceipt: string | null
    amount: number
    currency: string
    status: string
    riskScore: number
    createdAt: string
    updatedAt: string
}

const fetchTransactions = async () => {
    const { transactions } = await sdk.client.fetch<{ transactions: MpesaTransaction[] }>(`/admin/mpesa/transactions`, {
        method: "GET",
    })
    return transactions
}

// Ensure the route gets added to the main admin sidebar.
export const config = {
    link: {
        label: "M-Pesa",
        icon: "CurrencyDollar",
    },
}

export default function MpesaDashboard() {
    const { data: transactions, isLoading, isError } = useQuery({
        queryFn: fetchTransactions,
        queryKey: ["mpesa_transactions"],
    })

    // Basic styling for the status badges
    const getStatusColor = (status: string) => {
        switch (status) {
            case "captured":
            case "authorized":
                return "green"
            case "failed":
            case "expired":
            case "cancelled":
                return "red"
            case "under_review":
                return "orange"
            case "reversed":
                return "purple"
            default:
                return "grey"
        }
    }

    // Calculate high level metrics
    const totalVolume = transactions?.reduce((sum, tx) => sum + tx.amount, 0) || 0
    const successCount = transactions?.filter((tx) => tx.status === "captured").length || 0
    const reviewCount = transactions?.filter((tx) => tx.status === "under_review").length || 0

    return (
        <div className="flex flex-col gap-y-4">
            <Heading level="h1">M-Pesa Payments</Heading>

            {/* Metrics Row */}
            <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
                <Container className="p-6">
                    <Text className="text-ui-fg-subtle mb-1">Total Processed Volume</Text>
                    <Heading level="h2">KES {totalVolume.toLocaleString()}</Heading>
                </Container>
                <Container className="p-6">
                    <Text className="text-ui-fg-subtle mb-1">Captured Transactions</Text>
                    <Heading level="h2">{successCount}</Heading>
                </Container>
                <Container className="p-6">
                    <Text className="text-ui-fg-subtle mb-1">Pending Review</Text>
                    <Heading level="h2">{reviewCount}</Heading>
                </Container>
            </div>

            {/* Data Table */}
            <Container className="p-0 overflow-hidden">
                <div className="p-6 border-b border-ui-border-base">
                    <Heading level="h2">All Transactions</Heading>
                </div>

                {isLoading && <div className="p-6 text-center text-ui-fg-subtle">Loading transactions...</div>}
                {isError && <div className="p-6 text-center text-ui-fg-error">Failed to load transactions. Are you authenticated?</div>}

                {transactions && transactions.length === 0 && (
                    <div className="p-6 text-center text-ui-fg-subtle">No M-Pesa transactions yet.</div>
                )}

                {transactions && transactions.length > 0 && (
                    <Table>
                        <Table.Header>
                            <Table.Row>
                                <Table.HeaderCell>Receipt (M-Pesa ID)</Table.HeaderCell>
                                <Table.HeaderCell>Order ID</Table.HeaderCell>
                                <Table.HeaderCell>Phone Number</Table.HeaderCell>
                                <Table.HeaderCell>Amount</Table.HeaderCell>
                                <Table.HeaderCell>Risk Score</Table.HeaderCell>
                                <Table.HeaderCell>Status</Table.HeaderCell>
                                <Table.HeaderCell>Date</Table.HeaderCell>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {transactions.map((tx) => (
                                <Table.Row key={tx.id}>
                                    <Table.Cell className="font-mono text-ui-fg-subtle">
                                        {tx.mpesaReceipt || "Pending..."}
                                    </Table.Cell>
                                    <Table.Cell className="font-mono">{tx.orderId.substring(0, 13)}...</Table.Cell>
                                    <Table.Cell>{tx.phoneNumber}</Table.Cell>
                                    <Table.Cell>KES {tx.amount.toLocaleString()}</Table.Cell>
                                    <Table.Cell>
                                        <Text className={tx.riskScore > 20 ? "text-ui-fg-error font-medium" : ""}>
                                            {tx.riskScore}
                                        </Text>
                                    </Table.Cell>
                                    <Table.Cell>
                                        <Badge color={getStatusColor(tx.status)}>
                                            {tx.status}
                                        </Badge>
                                    </Table.Cell>
                                    <Table.Cell>
                                        {new Date(tx.createdAt).toLocaleString()}
                                    </Table.Cell>
                                </Table.Row>
                            ))}
                        </Table.Body>
                    </Table>
                )}
            </Container>
        </div>
    )
}
