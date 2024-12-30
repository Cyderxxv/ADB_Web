import express from "express"
import authMiddleware from "../middleware/authentication.js"
import { placeOrder, userOrders, verifyOrder, listOrders, updateStatus } from "../controllers/order.controller.js"

const orderRouter = express.Router();

orderRouter.post("/place",authMiddleware, placeOrder);
orderRouter.post("/verify", verifyOrder);
orderRouter.post("/userorders", authMiddleware, userOrders);
orderRouter.get('/list', listOrders)
orderRouter.post("/status", updateStatus)

export default orderRouter;