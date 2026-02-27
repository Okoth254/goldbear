const { Client } = require('pg');

const client = new Client({
  user: 'postgres',
  password: 'keepfighting', // Provided by user
  host: 'localhost',
  port: 5432,
  database: 'postgres',
});

async function createDb() {
  try {
    await client.connect();
    // Check if database exists
    const res = await client.query("SELECT 1 FROM pg_database WHERE datname = 'medusa-store'");
    if (res.rowCount === 0) {
      await client.query('CREATE DATABASE "medusa-store"');
      console.log("Database 'medusa-store' created successfully.");
    } else {
      console.log("Database 'medusa-store' already exists.");
    }
  } catch (err) {
    if (err.code === '28P01') {
      console.error("Authentication failed. Please verify your Postgres password.");
    } else {
      console.error("Error creating database:", err);
    }
  } finally {
    await client.end();
  }
}

createDb();
