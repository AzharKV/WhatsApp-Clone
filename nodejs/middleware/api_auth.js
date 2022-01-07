const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");

const User = mongoose.model("User");
const key = require("../key");

module.exports = (req, res, next) => {
  const { authorization } = req.headers;
  if (!authorization) {
    console.log("Invalid token ", req.method, " ", req.url);
    return res.status(401).json({ error: "you must be logged in" });
  }

  const token = authorization.replace("Bearer ", "");
  jwt.verify(token, key.JWT_SECRET, (error, payload) => {
    if (error) {
      console.log("Invalid token ", req.method, " ", req.url);
      return res.status(401).json({ error: "you must be logged in" });
    }

    const { _id } = payload;
    User.findById(_id).then((userData) => {
      req.user = userData;
      next();
    });
  });
};
