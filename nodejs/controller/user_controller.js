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
  updateUserStatus(socket, io);
  checkPendingMessages(socket);
};

function updateUserStatus(socket, io) {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: socket.id, status: true },
  }).exec((error) => {
    if (error) return console.log(error);

    let eventString = "/user_status" + socket.data.userId;

    io.emit(eventString, true);
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
    $set: { socketId: "", status: false, lastSeen: moment().format() },
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
        console.log(req.url, " ", req.method, " ", {
          createdAt: moment().format(),
          userData,
        });

        return res.json({
          createdAt: moment().format(),
          userData,
        });
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

const accountExist = (req, res) => {
  const phoneNumber = req.params.phone;

  User.findOne({ phone: phoneNumber }).then((savedUser) => {
    if (savedUser) {
      console.log(req.url, " ", req.method, "", savedUser);

      return res.json(savedUser);
    } else {
      console.log(req.url, " ", req.method, "", "Not found");

      return res.status(401).json({ status: false, message: "User not found" });
    }
  });
};

module.exports = {
  onUserConnect,
  disconnectUser,
  getUsers,
  userStatus,
  accountExist,
};
