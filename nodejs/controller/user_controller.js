const mongoose = require("mongoose");
require("../models/user");

const User = mongoose.model("User");

const updateUserStatus = (socket) => {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: socket.id, status: true },
  }).exec((error) => {
    if (error) console.log(error);
  });
};

const disconnectUser = (socket) => {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: "", status: false, lastSeen: Date.now() },
  }).exec((error) => {
    console.log("socket disconnected by ", socket.data.userName);
    if (error) console.log(error);
  });
};

module.exports = {
  updateUserStatus,
  disconnectUser,
};
