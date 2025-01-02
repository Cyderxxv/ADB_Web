import sql from "mssql";
import dotenv from "dotenv";

dotenv.config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: '192.168.0.71',
  database: process.env.DB_DATABASE,
  port: 1433,
  options: {
    encrypt: false, // Set to true if you're on Windows Azure
    trustServerCertificate: true, // Change to true for local dev / self-signed certs
    enableArithAbort: true, // Helps with certain connection issues
    connectTimeout: 30000, // Increase connection timeout
  },
};

console.log("Connecting with config:", config);

const connectDB = async () => {
  try {
    const pool = await sql.connect(config);
    console.log("MSSQL Connected");
    return pool;
  } catch (err) {
    // Detailed error logging
    console.error("Error connecting to MSSQL:", err.message);
    console.error("Error details:", {
      message: err.message,
      code: err.code,
      stack: err.stack,
      name: err.name,
    });
    process.exit(1);
  }
};

export default connectDB;