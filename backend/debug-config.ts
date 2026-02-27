const config = require('./medusa-config.ts');
console.log("Loaded Config:", JSON.stringify(config, null, 2));
console.log("Env DATABASE_URL:", process.env.DATABASE_URL);
