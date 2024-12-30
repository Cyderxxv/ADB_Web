import express from "express";
import { addCart, removeCart, getCart } from "../controllers/cart.controller.js";
import authenticationMiddleware from "../middleware/authentication.js";

const cartRouter = express.Router();

cartRouter.post("/add", authenticationMiddleware, addCart);
cartRouter.post("/remove", authenticationMiddleware, removeCart);
cartRouter.post("/get", authenticationMiddleware, getCart);

export default cartRouter;