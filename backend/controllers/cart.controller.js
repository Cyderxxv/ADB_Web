import sql from "mssql";
import config from "../config/db.js";

const addCart = async (req, res) => {
    try {
        const { userId, itemId } = req.body;
        if (!userId || !itemId) {
            return res.status(400).json({ success: false, message: "User ID and Item ID are required" });
        }

        const pool = await sql.connect(config);

        // Check if user exists
        const userResult = await pool.request()
            .input("userId", sql.Int, userId)
            .query("SELECT * FROM MembershipDetail WHERE card_id = @userId");

        if (userResult.recordset.length === 0) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        // Check if item is already in the cart
        const cartResult = await pool.request()
            .input("userId", sql.Int, userId)
            .input("itemId", sql.Int, itemId)
            .query("SELECT * FROM Cart WHERE user_id = @userId AND item_id = @itemId");

        if (cartResult.recordset.length === 0) {
            // Add new item to cart
            await pool.request()
                .input("userId", sql.Int, userId)
                .input("itemId", sql.Int, itemId)
                .input("quantity", sql.Int, 1)
                .query("INSERT INTO Cart (user_id, item_id, quantity) VALUES (@userId, @itemId, @quantity)");
        } else {
            // Update quantity of existing item in cart
            await pool.request()
                .input("userId", sql.Int, userId)
                .input("itemId", sql.Int, itemId)
                .query("UPDATE Cart SET quantity = quantity + 1 WHERE user_id = @userId AND item_id = @itemId");
        }

        res.json({ success: true, message: "Item added to cart" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error detected" });
    }
};

const removeCart = async (req, res) => {
    try {
        const { userId, itemId } = req.body;
        if (!userId || !itemId) {
            return res.status(400).json({ success: false, message: "User ID and Item ID are required" });
        }

        const pool = await sql.connect(config);

        // Check if user exists
        const userResult = await pool.request()
            .input("userId", sql.Int, userId)
            .query("SELECT * FROM MembershipDetail WHERE card_id = @userId");

        if (userResult.recordset.length === 0) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        // Check if item is in the cart
        const cartResult = await pool.request()
            .input("userId", sql.Int, userId)
            .input("itemId", sql.Int, itemId)
            .query("SELECT * FROM Cart WHERE user_id = @userId AND item_id = @itemId");

        if (cartResult.recordset.length === 0) {
            return res.status(404).json({ success: false, message: "Item not found in cart" });
        }

        // Update quantity or remove item from cart
        const item = cartResult.recordset[0];
        if (item.quantity > 1) {
            await pool.request()
                .input("userId", sql.Int, userId)
                .input("itemId", sql.Int, itemId)
                .query("UPDATE Cart SET quantity = quantity - 1 WHERE user_id = @userId AND item_id = @itemId");
        } else {
            await pool.request()
                .input("userId", sql.Int, userId)
                .input("itemId", sql.Int, itemId)
                .query("DELETE FROM Cart WHERE user_id = @userId AND item_id = @itemId");
        }

        res.json({ success: true, message: "Removed from cart" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error detected" });
    }
};

const getCart = async (req, res) => {
    try {
        const userId = req.user?.id;
        if (!userId) {
            return res.status(401).json({ success: false, message: "User not authenticated" });
        }

        const pool = await sql.connect(config);

        // Check if user exists
        const userResult = await pool.request()
            .input("userId", sql.Int, userId)
            .query("SELECT * FROM MembershipDetail WHERE card_id = @userId");

        if (userResult.recordset.length === 0) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        // Get cart items
        const cartResult = await pool.request()
            .input("userId", sql.Int, userId)
            .query("SELECT * FROM Cart WHERE user_id = @userId");

        const cartData = cartResult.recordset.reduce((acc, item) => {
            acc[item.item_id] = item.quantity;
            return acc;
        }, {});

        res.json({ success: true, cartData });
    } catch (error) {
        console.error("Error in getCart:", error);
        res.status(500).json({ success: false, message: "Error detected" });
    }
};

export { addCart, removeCart, getCart };