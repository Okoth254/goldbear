import { ExecArgs } from "@medusajs/framework/types";
import {
    ContainerRegistrationKeys,
    Modules,
    ProductStatus,
} from "@medusajs/framework/utils";
import {
    createProductCategoriesWorkflow,
    createProductsWorkflow,
} from "@medusajs/medusa/core-flows";

export default async function seedDemoData({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER);
    const salesChannelModuleService = container.resolve(Modules.SALES_CHANNEL);
    const fulfillmentModuleService = container.resolve(Modules.FULFILLMENT);

    logger.info("Initializing Furniture Seeding...");

    // Get Default Sales Channel
    const salesChannels = await salesChannelModuleService.listSalesChannels({
        name: "Default Sales Channel",
    });
    if (!salesChannels.length) {
        logger.error("Default Sales Channel not found. Please run the main seed.ts first.");
        return;
    }
    const defaultSalesChannel = salesChannels[0];

    // Get Default Shipping Profile
    const shippingProfiles = await fulfillmentModuleService.listShippingProfiles({
        type: "default",
    });
    if (!shippingProfiles.length) {
        logger.error("Default Shipping Profile not found. Please run the main seed.ts first.");
        return;
    }
    const defaultShippingProfile = shippingProfiles[0];

    logger.info("Creating Furniture Categories...");

    const { result: categoryResult } = await createProductCategoriesWorkflow(
        container
    ).run({
        input: {
            product_categories: [
                { name: "Living Room", is_active: true },
                { name: "Bedroom", is_active: true },
                { name: "Dining", is_active: true },
                { name: "Home Office", is_active: true },
                { name: "Outdoor", is_active: true },
                { name: "Modular & Smart", is_active: true },
            ],
        },
    });

    const getCategoryId = (name: string) => categoryResult.find((cat) => cat.name === name)!.id;

    logger.info("Creating Furniture Products...");

    await createProductsWorkflow(container).run({
        input: {
            products: [
                // LIVING ROOM
                {
                    title: "Aurora Modular Sofa",
                    category_ids: [getCategoryId("Living Room")],
                    description: "A flexible modular sofa designed for creative living spaces. Features stain-resistant fabric and plush cushions.",
                    handle: "aurora-modular-sofa",
                    weight: 45000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Color", values: ["Forest Green", "Oatmeal"] }],
                    variants: [
                        {
                            title: "Forest Green",
                            sku: "AUR-SOFA-GRN",
                            options: { Color: "Forest Green" },
                            prices: [{ amount: 1200, currency_code: "usd" }, { amount: 1100, currency_code: "eur" }],
                        },
                        {
                            title: "Oatmeal",
                            sku: "AUR-SOFA-OAT",
                            options: { Color: "Oatmeal" },
                            prices: [{ amount: 1200, currency_code: "usd" }, { amount: 1100, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },
                {
                    title: "Lunar Marble Center Table",
                    category_ids: [getCategoryId("Living Room")],
                    description: "Elegantly sculpted marble coffee table that acts as the centerpiece of any modern living room.",
                    handle: "lunar-marble-center-table",
                    weight: 25000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1533090481720-856c6e3c1fdc?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Finish", values: ["White Carrara", "Black Marquina"] }],
                    variants: [
                        {
                            title: "White Carrara",
                            sku: "LUNAR-TBL-WHT",
                            options: { Finish: "White Carrara" },
                            prices: [{ amount: 450, currency_code: "usd" }, { amount: 400, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },

                // BEDROOM
                {
                    title: "Atlas Storage Bed Frame",
                    category_ids: [getCategoryId("Bedroom"), getCategoryId("Modular & Smart")],
                    description: "Maximize your bedroom space with deep, built-in hydraulic storage compartments beneath the mattress.",
                    handle: "atlas-storage-bed",
                    weight: 85000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Size", values: ["Queen", "King"] }],
                    variants: [
                        {
                            title: "Queen",
                            sku: "ATLAS-BED-QN",
                            options: { Size: "Queen" },
                            prices: [{ amount: 899, currency_code: "usd" }, { amount: 820, currency_code: "eur" }],
                        },
                        {
                            title: "King",
                            sku: "ATLAS-BED-KG",
                            options: { Size: "King" },
                            prices: [{ amount: 1099, currency_code: "usd" }, { amount: 1000, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },
                {
                    title: "Drift Scandinavian Dresser",
                    category_ids: [getCategoryId("Bedroom")],
                    description: "Minimalist oak wood dresser with 6 spacious drawers featuring soft-close mechanisms.",
                    handle: "drift-scandi-dresser",
                    weight: 54000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Wood", values: ["Light Oak", "Walnut"] }],
                    variants: [
                        {
                            title: "Light Oak",
                            sku: "DFT-DRSS-LOK",
                            options: { Wood: "Light Oak" },
                            prices: [{ amount: 550, currency_code: "usd" }, { amount: 500, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },

                // DINING
                {
                    title: "Monarch Extendable Dining Table",
                    category_ids: [getCategoryId("Dining")],
                    description: "A solid wood dining table that easily extends to seat 10 people for large family gatherings.",
                    handle: "monarch-dining-table",
                    weight: 70000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1604578762246-41134e37f9cc?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Size", values: ["Standard"] }],
                    variants: [
                        {
                            title: "Standard",
                            sku: "MON-TBL-STD",
                            options: { Size: "Standard" },
                            prices: [{ amount: 799, currency_code: "usd" }, { amount: 750, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },
                {
                    title: "Nova Stackable Dining Chair",
                    category_ids: [getCategoryId("Dining"), getCategoryId("Modular & Smart")],
                    description: "Sleek, ergonomic dining chairs that can be easily stacked to save space when not in use.",
                    handle: "nova-stackable-chair",
                    weight: 6000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Color", values: ["Matte Black", "Mustard Yellow"] }],
                    variants: [
                        {
                            title: "Matte Black",
                            sku: "NOVA-CHR-BLK",
                            options: { Color: "Matte Black" },
                            prices: [{ amount: 120, currency_code: "usd" }, { amount: 110, currency_code: "eur" }],
                        },
                        {
                            title: "Mustard Yellow",
                            sku: "NOVA-CHR-MST",
                            options: { Color: "Mustard Yellow" },
                            prices: [{ amount: 120, currency_code: "usd" }, { amount: 110, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },

                // HOME OFFICE & SMART
                {
                    title: "Zenith Smart Standing Desk",
                    category_ids: [getCategoryId("Home Office"), getCategoryId("Modular & Smart")],
                    description: "Motorized sit-stand desk with built-in wireless charging pad and programmable heights.",
                    handle: "zenith-smart-desk",
                    weight: 42000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Width", values: ["48 inch", "60 inch"] }],
                    variants: [
                        {
                            title: "48 inch",
                            sku: "ZEN-DSK-48",
                            options: { Width: "48 inch" },
                            prices: [{ amount: 599, currency_code: "usd" }, { amount: 550, currency_code: "eur" }],
                        },
                        {
                            title: "60 inch",
                            sku: "ZEN-DSK-60",
                            options: { Width: "60 inch" },
                            prices: [{ amount: 699, currency_code: "usd" }, { amount: 650, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },
                {
                    title: "Titan Ergonomic Office Chair",
                    category_ids: [getCategoryId("Home Office")],
                    description: "Premium breathable mesh chair providing superior lumbar support for long working hours.",
                    handle: "titan-ergonomic-chair",
                    weight: 18000,
                    status: ProductStatus.PUBLISHED,
                    shipping_profile_id: defaultShippingProfile.id,
                    images: [{ url: "https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?auto=format&fit=crop&w=1000&q=80" }],
                    options: [{ title: "Color", values: ["Charcoal", "Ash Gray"] }],
                    variants: [
                        {
                            title: "Charcoal",
                            sku: "TITAN-CHR-CHAR",
                            options: { Color: "Charcoal" },
                            prices: [{ amount: 350, currency_code: "usd" }, { amount: 320, currency_code: "eur" }],
                        },
                    ],
                    sales_channels: [{ id: defaultSalesChannel.id }],
                },
            ],
        },
    });

    logger.info("Successfully Seeded Furniture Catalog!");
}
