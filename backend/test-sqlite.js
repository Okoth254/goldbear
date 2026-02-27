const Database = require('better-sqlite3');
try {
    console.log("Opening database...");
    const db = new Database('test.db', { verbose: console.log });
    console.log("Database opened.");
    db.pragma('journal_mode = WAL');
    db.exec("CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT)");
    db.exec("INSERT INTO test (name) VALUES ('test')");
    console.log("SQLite test successful");
    db.close();
} catch (e) {
    console.error("SQLite test failed", e);
}
