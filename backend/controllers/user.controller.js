import userModel from "../models/user.model.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import validator from "validator";

const createToken = (id) => {
    return jwt.sign({id}, process.env.JWT_SECRET);
}

const login = async(req, res) => {
    const {email, password} = req.body;
    try {
        const user = await userModel.findOne({email});
        if(!user) {
            return res.json({success: false, message: "Account doesnt exist"});
        }

        const check = await bcrypt.compare(password, user.password);
        if(!check) {
            return res.json({success: false, message: "Password incorrect!"});
        }

        const token = createToken(user._id);
        res.json({success: true, token});
    } catch(error) {
        console.log(error);
        res.json({success: false, message: "Error detected"});
    }
}

const register = async(req, res) => {
    const {name, password, email} = req.body;
    try {
        const ifExists = await userModel.findOne({email});
        if(ifExists) {
            return res.json({success: false, message: "Email already registered to another account"});
        }

        if(!validator.isEmail(email)) {
            return res.json({success: false, message: "Enter a vaild email"});
        }

        if(password.length < 8) {
            return res.json({success: false, message: "Password must have at least 8 characters above!"});
        }


        // Hash
        const salt = await bcrypt.genSalt(10);
        const hashed = await bcrypt.hash(password, salt);

        const newUser = new userModel({
            name: name,
            email: email,
            password: hashed
        });

        const user = await newUser.save();
        const token = createToken(user._id);
        res.json({success: true, token});
    } catch(error) {
        console.log(error);
        res.json({success: false, message: "Error detected"});
    }
}

export {login, register};