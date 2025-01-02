import sql from "mssql";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import validator from "validator";
import config from "../config/db.js";

const createToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET);
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .input("email", sql.NVarChar, email)
      .query("SELECT * FROM MembershipDetail WHERE email = @email");

    if (result.recordset.length === 0) {
      return res.json({ success: false, message: "Account doesn't exist" });
    }

    const user = result.recordset[0];
    const check = await bcrypt.compare(password, user.password);
    if (!check) {
      return res.json({ success: false, message: "Password incorrect!" });
    }

    const token = createToken(user.card_id);
    res.json({ success: true, token });
  } catch (error) {
    console.log(error);
    res.json({ success: false, message: "Error detected" });
  }
};

const register = async (req, res) => {
  const { name, password, email, gender } = req.body; // Remove personal_id from destructuring

  try {
    const pool = await sql.connect(config);
    const ifExists = await pool.request()
      .input("email", sql.NVarChar, email)
      .query("SELECT * FROM MembershipDetail WHERE email = @email");

    if (ifExists.recordset.length > 0) {
      return res.json({ success: false, message: "Email already registered to another account" });
    }

    if (!validator.isEmail(email)) {
      return res.json({ success: false, message: "Enter a valid email" });
    }

    if (password.length < 8) {
      return res.json({ success: false, message: "Password must have at least 8 characters!" });
    }

    // Hash the password
    const salt = await bcrypt.genSalt(10);
    const hashed = await bcrypt.hash(password, salt);

    // Automatically generate the personal_id if not provided
    const generatedPersonalId = `PID${Date.now()}`;

    // Insert new user into MembershipDetail
    const result = await pool.request()
      .input("password", sql.NVarChar, hashed)
      .input("email", sql.NVarChar, email)
      .input("personal_id", sql.Char, generatedPersonalId) // Always include the generated personal_id
      .input("gender", sql.NVarChar, gender)
      .input("is_enable", sql.Bit, true)
      .query(`
        INSERT INTO MembershipDetail (password, email, personal_id, gender, is_enable)
        OUTPUT INSERTED.card_id
        VALUES (@password, @email, @personal_id, @gender, @is_enable)
      `);

    const newUser = result.recordset[0];
    const token = createToken(newUser.card_id);
    res.json({ success: true, token });
  } catch (error) {
    console.log(error);
    res.json({ success: false, message: "Error detected" });
  }
};


export { login, register };