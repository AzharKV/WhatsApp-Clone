const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");

const User = mongoose.model("User");
const key = require("../key");

module.exports = (socket) => {
  socket.on("/singleChat", function (msg) {
    console.log(msg);
    const token = msg.to;

    jwt.verify(token, key.JWT_SECRET, (error, payload) => {
      if (error) console.log("Invalid Token");

      const id = payload;

      User.findById(id).then((userData) => {
        if (userData) {
          let socketId = userData.socketId;
          console.log(socketId);
          console.log(userData.name);
          socket.to(socketId).emit("/singleChat", "message received");
        }
      });
    });
  });
};
