import { Container, Heading, Table, Badge } from "@medusajs/ui"
import { useReconciliationLogs, ReconciliationLog } from "../../../hooks/api"

export const config = {
    link: {
        label: "M-Pesa Reconciliation",
        icon: "Clock",
    },
}

export default function ReconciliationLogs() {
    const { data, isLoading, isError } = useReconciliationLogs()
    const logs = (data as unknown as { logs: ReconciliationLog[] })?.logs

    const getSeverityBadge = (action: string) => {
        if (action.includes("CRITICAL")) return <Badge color="red">{action}</Badge>
        if (action.includes("recovery")) return <Badge color="orange">{action}</Badge>
        if (action.includes("captured")) return <Badge color="green">{action}</Badge>
        return <Badge color="grey">{action}</Badge>
    }

    return (
        <div className="flex flex-col gap-y-4">
            <Heading level="h1">Reconciliation Logs</Heading>
            <Container className="p-0 overflow-hidden">
                <div className="p-6 border-b border-ui-border-base">
                    <Heading level="h2">Nightly Cron Reports</Heading>
                </div>

                {isLoading && <div className="p-6 text-center text-ui-fg-subtle">Fetching logs...</div>}
                {isError && <div className="p-6 text-center text-ui-fg-error">Failed to load reconciliation logs.</div>}

                {logs && logs.length === 0 && (
                    <div className="p-6 text-center text-ui-fg-subtle">No reconciliation discrepancies recorded yet. Great!</div>
                )}

                {logs && logs.length > 0 && (
                    <Table>
                        <Table.Header>
                            <Table.Row>
                                <Table.HeaderCell>Transaction ID</Table.HeaderCell>
                                <Table.HeaderCell>Daraja Status</Table.HeaderCell>
                                <Table.HeaderCell>Internal DB Status</Table.HeaderCell>
                                <Table.HeaderCell>System Action Taken</Table.HeaderCell>
                                <Table.HeaderCell>Date</Table.HeaderCell>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {logs.map((log) => (
                                <Table.Row key={log.id}>
                                    <Table.Cell className="font-mono text-ui-fg-subtle">
                                        {log.transaction.id.substring(0, 13)}...
                                    </Table.Cell>
                                    <Table.Cell>
                                        <Badge color={log.darajaStatus === "Missing" ? "red" : "blue"}>
                                            {log.darajaStatus}
                                        </Badge>
                                    </Table.Cell>
                                    <Table.Cell>{log.internalStatus}</Table.Cell>
                                    <Table.Cell>{getSeverityBadge(log.actionTaken)}</Table.Cell>
                                    <Table.Cell>{new Date(log.timestamp).toLocaleString()}</Table.Cell>
                                </Table.Row>
                            ))}
                        </Table.Body>
                    </Table>
                )}
            </Container>
        </div>
    )
}
