const mongoose = require("mongoose");

const User = mongoose.model("User");

const router = require("express").Router();

const sendMessage = (req, res) => {
  const { message, from, to, date } = req.body;

  const io = req.io;

  //get user socket id from db

  User.findById(to).then((userData) => {
    const socketId = userData.socketId;

    //using req.io emit message to the socket id

    const data = {
      message: message,
      from: from,
      to: to,
      date: date,
    };

    io.to(socketId).emit("message", data);

    res.json({ message: "Success" });
  });
};

module.exports = {
  sendMessage,
};
