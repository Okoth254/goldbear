import { ExecArgs } from "@medusajs/framework/types";
import { ContainerRegistrationKeys } from "@medusajs/framework/utils";

export default async function getRegionsShort({ container }: ExecArgs) {
    const query = container.resolve(ContainerRegistrationKeys.QUERY);
    const { data: regions } = await query.graph({
        entity: "region",
        fields: ["id", "name", "currency_code"],
    });

    console.log("REGIONS_DEBUG_START");
    console.log(JSON.stringify(regions, null, 2));
    console.log("REGIONS_DEBUG_END");
}
