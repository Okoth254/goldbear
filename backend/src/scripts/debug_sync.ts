import { ExecArgs } from "@medusajs/framework/types";
import { ContainerRegistrationKeys } from "@medusajs/framework/utils";

export default async function getRegions({ container }: ExecArgs) {
    const query = container.resolve(ContainerRegistrationKeys.QUERY);
    const { data: regions } = await query.graph({
        entity: "region",
        fields: ["id", "name", "currency_code", "countries.iso_2"],
    });

    const { data: currencies } = await query.graph({
        entity: "currency",
        fields: ["code", "name"],
    });

    const { data: stores } = await query.graph({
        entity: "store",
        fields: ["id", "name", "supported_currencies.currency_code", "default_sales_channel_id"],
    });

    console.log("SYNC_DEBUG_START");
    console.log(JSON.stringify({ regions, currencies, stores }, null, 2));
    console.log("SYNC_DEBUG_END");
}
