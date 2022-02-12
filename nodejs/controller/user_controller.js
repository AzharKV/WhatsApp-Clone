const mongoose = require("mongoose");
require("../models/user");

const User = mongoose.model("User");

const moment = require("moment");

const updateUserStatus = (socket, io) => {
  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: socket.id, status: true },
  }).exec((error) => {
    if (error) return console.log(error);

    let eventString = "/user_status" + socket.data.userId;

    io.emit(eventString, true);
  });
};

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

module.exports = {
  updateUserStatus,
  disconnectUser,
  getUsers,
  userStatus,
};
