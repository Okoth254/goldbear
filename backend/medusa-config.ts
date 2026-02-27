import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
  },
  modules: [
    {
      // Register M-Pesa as a payment provider within Medusa's built-in payment module
      resolve: "@medusajs/medusa/payment",
      options: {
        providers: [
          {
            resolve: "./src/modules/mpesa",
            id: "mpesa",
            options: {
              consumerKey: process.env.MPESA_CONSUMER_KEY,
              consumerSecret: process.env.MPESA_CONSUMER_SECRET,
              shortcode: process.env.MPESA_SHORTCODE,
              passkey: process.env.MPESA_PASSKEY,
              initiatorName: process.env.MPESA_INITIATOR_NAME,
              securityCredential: process.env.MPESA_SECURITY_CREDENTIAL,
              callbackBaseUrl: process.env.MPESA_CALLBACK_BASE_URL,
              environment: process.env.MPESA_ENV ?? "sandbox",
              redisUrl: process.env.REDIS_URL,
              slackWebhookUrl: process.env.SLACK_WEBHOOK_URL,
            },
          },
        ],
      },
    },
    {
      resolve: "@medusajs/auth",
      options: {
        providers: [
          {
            resolve: "@medusajs/auth-emailpass",
            id: "emailpass",
            options: {
              // Optional: Add specific options for emailpass here
            },
          },
        ],
      },
    },
  ],
})
