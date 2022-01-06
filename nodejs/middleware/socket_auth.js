const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");

const User = mongoose.model("User");
const key = require("../key");

module.exports = (socket, next) => {
  const token = socket.handshake.auth.token;

  jwt.verify(token, key.JWT_SECRET, (error, payload) => {
    if (error) return next(Error("Invalid Token"));

    const id = payload;

    User.findById(id).then((userData) => {
      if (userData) {
        socket.data = { userId: userData._id, userName: userData.name };
        console.log("socket connected by",userData.name);
        return next();
      } else return next(Error("Invalid Token else"));
    });
  });
};
