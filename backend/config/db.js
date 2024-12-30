import sql from "mssql";
import dotenv from "dotenv";

dotenv.config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_DATABASE,
};

const connectDB = async () => {
  try {
    const pool = await sql.connect(config);
    console.log("MSSQL Connected");
    return pool;
  } catch (err) {
    console.error("Error connecting to MSSQL:", err.message);
    process.exit(1);
  }
};

export default connectDB;