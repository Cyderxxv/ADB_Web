import orderModel from "../models/order.model.js";
import userModel from '../models/user.model.js';
import paypal from "@paypal/checkout-server-sdk";
import dotenv from 'dotenv';
dotenv.config();

const environment = new paypal.core.SandboxEnvironment(
    process.env.PAYPAL_CLIENT_ID, 
    process.env.PAYPAL_CLIENT_SECRET
);
const paypalClient = new paypal.core.PayPalHttpClient(environment);
console.log("PayPal Client ID:", process.env.PAYPAL_CLIENT_ID);
console.log("PayPal Client Secret:", process.env.PAYPAL_CLIENT_SECRET ? "****" : "Missing");


const frontend_url = "http://localhost:5173";

const placeOrder = async (req, res) => {
    try {
        const { items, amount, address } = req.body;
        const userId = req.user?.id;


        console.log(userId,items,amount,address)

        if (!userId || !items || !amount || !address) {
            return res.status(400).json({ success: false, message: "Missing required fields." });
        }

        const newOrder = new orderModel({
            userId: userId,
            items: items,
            amount: amount,
            address: address,
            paymentMethod: 'paypal'
        });

        await newOrder.save();
        await userModel.findByIdAndUpdate(userId, { cartData: {} });

        const totalAmount = items.reduce((total, item) => 
            total + (item.price * item.quantity), 0) + 2;

        const request = new paypal.orders.OrdersCreateRequest();
        request.prefer('return=representation');
        request.requestBody({
            intent: 'CAPTURE',
            purchase_units: [{
                amount: {
                    currency_code: 'USD',
                    value: totalAmount.toFixed(2) 
                },
                reference_id: newOrder._id.toString()
            }],
            application_context: {
                return_url: `${frontend_url}/verify?success=true&orderId=${newOrder._id}`,
                cancel_url: `${frontend_url}/verify?success=false&orderId=${newOrder._id}`
            }
        });

        const paypalOrder = await paypalClient.execute(request);
        res.json({ 
            success: true, 
            session_url: paypalOrder.result.links.find(link => link.rel === "approve").href 
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error creating order." });
    }
};

const verifyOrder = async (req, res) => {
    const { orderId, paymentId, PayerID } = req.body;

    try {
        if (!orderId || !paymentId || !PayerID) {
            return res.status(400).json({ success: false, message: "Missing required parameters." });
        }

        const captureRequest = new paypal.orders.OrdersCaptureRequest(paymentId);
        const capture = await paypalClient.execute(captureRequest);

        if (capture.result.status === 'COMPLETED') {
            await orderModel.findByIdAndUpdate(orderId, { 
                payment: true, 
                paymentMethod: 'paypal',
                paypalTransactionId: paymentId
            });
            res.json({ success: true, message: "Payment Successful" });
        } else {
            await orderModel.findByIdAndDelete(orderId);
            res.json({ success: false, message: "Payment Failed" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error verifying payment" });
    }
};

const userOrders = async (req, res) => {
    try {
        const userId = req.user?.id;
        if (!userId) {
            return res.status(400).json({ success: false, message: "User not authenticated" });
        }

        const orders = await orderModel.find({ userId });
        res.json({ success: true, data: orders });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error fetching user orders" });
    }
};

const listOrders = async (req, res) => {
    try {   
        const orders = await orderModel.find({});
        res.json({ success: true, data: orders });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error fetching orders" });
    }
};

const updateStatus = async (req, res) => {
    try {
        const { orderId, status } = req.body;
        if (!orderId || !status) {
            return res.status(400).json({ success: false, message: "Order ID and status are required" });
        }

        await orderModel.findByIdAndUpdate(orderId, { status });
        res.json({ success: true, message: "Status Updated" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error updating order status" });
    }
};

export { placeOrder, verifyOrder, userOrders, listOrders, updateStatus };
