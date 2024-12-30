import jwt from "jsonwebtoken";

const authenticationMiddleware = (req, res, next) => {
    const token = req.headers.token;
    if (!token) {
        return res.status(401).json({ success: false, message: "Unauthorized. Token is missing." });
    }

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
        req.user = { id: decodedToken.id };

        next();
    } catch (error) {
        console.error("JWT Verification Error:", error.message);
        if (error.name === "TokenExpiredError") {
            return res.status(401).json({ success: false, message: "Token has expired. Please log in again." });
        }

        if (error.name === "JsonWebTokenError") {
            return res.status(403).json({ success: false, message: "Invalid token. Access denied." });
        }

        res.status(500).json({ success: false, message: "Internal server error." });
    }
};

export default authenticationMiddleware;
