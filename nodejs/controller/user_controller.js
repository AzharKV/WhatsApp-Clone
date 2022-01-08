const mongoose = require("mongoose");
require("../models/user");

const User = mongoose.model("User");

const moment = require("moment");

const updateUserStatus = (socket) => {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: socket.id, status: true },
  }).exec((error) => {
    if (error) console.log(error);
  });
};

const disconnectUser = (socket) => {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: "", status: false, lastSeen: moment().format() },
  }).exec((error) => {
    console.log("socket disconnected by ", socket.data.userName);
    if (error) console.log(error);
  });
};

module.exports = {
  updateUserStatus,
  disconnectUser,
};
