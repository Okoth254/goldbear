import { ExecArgs } from "@medusajs/framework/types";
import { ContainerRegistrationKeys } from "@medusajs/framework/utils";

export default async function getKey({ container }: ExecArgs) {
    const query = container.resolve(ContainerRegistrationKeys.QUERY);
    const { data } = await query.graph({
        entity: "api_key",
        fields: ["id", "title", "token"],
        filters: {
            type: "publishable",
        },
    });

    console.log("PUBLISHABLE_KEYS_START");
    console.log(JSON.stringify(data, null, 2));
    console.log("PUBLISHABLE_KEYS_END");
}
