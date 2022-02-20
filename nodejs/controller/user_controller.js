const mongoose = require("mongoose");
require("../models/user");
require("../models/message");
require("../models/pending_message");

const User = mongoose.model("User");
const Message = mongoose.model("Message");
const PendingMessage = mongoose.model("PendingMessage");

const moment = require("moment");
const e = require("express");

const onUserConnect = (socket, io) => {
  updateSocketId(socket);
  checkPendingMessages(socket);
};

function updateSocketId(socket) {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: socket.id },
  }).exec((error) => {
    if (error) return console.log(error);
  });
}

function checkPendingMessages(socket) {
  PendingMessage.find({ toUserId: socket.data.userId })
    .then((data) => {
      data.forEach((element) => {
        //get message content by element._id

        Message.findById(element._id).then((messageData) => {
          if (messageData == null) {
            Message.findByIdAndRemove(element._id);
          } else {
            const data = {
              id: messageData._id,
              message: messageData.message,
              from: messageData.from,
              to: messageData.to,
              messageType: messageData.messageType,
              filePath: messageData.filePath,
              createdAt: messageData.createdAt,
            };

            //send by socket

            socket.emit("message", data);
          }
          //remove from pending
          PendingMessage.findByIdAndRemove(element._id);
        });
      });
    })
    .catch((error) => console.log("check pending error ", error));
}

const disconnectUser = (socket, io) => {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: "" },
  }).exec((error) => {
    if (error) return console.log(error);

    let eventString = "/user_status" + socket.data.userId;

    io.emit(eventString, false);

    console.log("socket disconnected by ", socket.data.userName);
  });
};

const getUsers = (req, res) => {
  User.find({ _id: { $ne: req.user._id } })
    .select("-__v")
    .then((data) => {
      const result = {
        createdAt: moment().format(),
      };

      result.users = data;

      console.log(req.url, " ", req.method, " ", result);
      return res.json(result);
    })
    .catch((error) =>
      res.status(500).json({ error: "Internal Server Error" + error })
    );
};

const userStatus = (req, res) => {
  const id = req.params.id;

  User.findById(id)
    .select("-__v")
    .then((userData) => {
      const result = {
        createdAt: moment().format(),
        status: userData.status,
      };

      if (userData) {
        console.log(req.url, " ", req.method, " ", result);

        return res.json(result);
      } else {
        console.log(req.url, " ", req.method, " ", {
          createdAt: moment().format(),
          message: "Invalid user id",
        });

        return res.status(401).json({
          createdAt: moment().format(),
          message: "Invalid user id",
        });
      }
    });
};

const updateUserStatus = (req, res) => {
  const { status } = req.body;
  const userId = req.user._id;

  const io = req.io;

  let updateData = { status: status };

  if (status == "false")
    updateData = { status: false, lastSeen: moment().format() };

  User.findByIdAndUpdate(userId, {
    $set: updateData,
  }).exec((error) => {
    if (error) return console.log(error);

    let eventString = "/user_status" + userId;

    let userStatus = false;

    if (status == "true") userStatus = true;

    io.emit(eventString, userStatus);

    return res.json({
      status: true,
      message: "Successfully updated",
    });
  });
};

const getUserDetails = (req, res) => {
  const phoneNumber = req.params.phone;

  if (phoneNumber.length > 5) {
    User.findOne({ phone: phoneNumber }, (error, data) => {
      if (data != null) {
        const result = {
          id: data._id,
          name: data.name,
          phone: data.phone,
          imageUrl: data.imageUrl,
          about: data.about,
          createdAt: moment().format(),
        };

        console.log(req.url, " ", req.method, " ", result);
        return res.json(result);
      } else {
        const result = { status: false, message: "User not found" };

        console.log(req.url, " ", req.method, " ", result);
        return res.status(404).json(result);
      }
    });
  } else {
    const result = { status: false, message: "Invalid number" };

    console.log(req.url, " ", req.method, " ", result);
    return res.status(400).json(result);
  }
};

module.exports = {
  onUserConnect,
  disconnectUser,
  getUsers,
  userStatus,
  updateUserStatus,
  getUserDetails,
};
