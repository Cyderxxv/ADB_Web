import userModel from "../models/user.model.js";

const addCart = async (req, res) => {
    try {
        if (!req.body.userId || !req.body.itemId) {
            return res.status(400).json({ success: false, message: "User ID and Item ID are required" });
        }

        let userData = await userModel.findById(req.body.userId);
        if (!userData) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        let cartData = userData.cartData || {};
        if (!cartData[req.body.itemId]) {
            cartData[req.body.itemId] = 1;
        } else {
            cartData[req.body.itemId] += 1;
        }

        await userModel.findByIdAndUpdate(req.body.userId, { cartData });
        res.json({ success: true, message: "Item added to cart" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error detected" });
    }
};

const removeCart = async (req, res) => {
    try {
        if (!req.body.userId || !req.body.itemId) {
            return res.status(400).json({ success: false, message: "User ID and Item ID are required" });
        }

        let userData = await userModel.findById(req.body.userId);
        if (!userData) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        let cartData = userData.cartData || {};
        if (cartData[req.body.itemId] > 0) {
            cartData[req.body.itemId] -= 1;
        }

        await userModel.findByIdAndUpdate(req.body.userId, { cartData });
        res.json({ success: true, message: "Removed from cart" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error detected" });
    }
};


const getCart = async (req, res) => {
    try {
        const userId = req.user?.id;
        console.log("Auth Token:", req.headers.token); // Debug log
        console.log("User ID from token:", userId);    // Debug log

        if (!userId) {
            return res.status(401).json({ 
                success: false, 
                message: "User not authenticated" 
            });
        }

        let userData = await userModel.findById(userId);
        if (!userData) {
            return res.status(404).json({ 
                success: false, 
                message: "User not found" 
            });
        }

        let cartData = userData.cartData || {};
        res.json({ success: true, cartData });
    } catch (error) {
        console.error("Error in getCart:", error);
        res.status(500).json({ 
            success: false, 
            message: "Error detected" 
        });
    }
};

export { addCart, removeCart, getCart };