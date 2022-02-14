const mongoose = require("mongoose");

const User = mongoose.model("User");
const Message = mongoose.model("Message");
const PendingMessage = mongoose.model("PendingMessage");

const sendMessage = (req, res) => {
  try {
    const { id, message, from, to, createdAt, filePath, messageType } =
      req.body;

    const messageData = new Message({
      _id: id,
      message: message,
      from: from,
      to: to,
      messageType: messageType,
      filePath: filePath,
      createdAt: createdAt,
    });

    //save message to server db
    messageData.save().then((newMessage) => {
      const pendingMessageData = new PendingMessage({
        _id: id,
        toUserId: to,
      });

      //add message id with to user id
      pendingMessageData.save().then((newPendingMessageData) => {
        const io = req.io;
        //get user socket id from db
        User.findById(to).then((userData) => {
          const socketId = userData.socketId;
          //using req.io emit message to the socket id
          const data = {
            id: id,
            message: message,
            from: from,
            to: to,
            messageType: messageType,
            filePath: filePath,
            createdAt: createdAt,
          };
          io.to(socketId).emit("message", data);

          console.log(req.url, " ", req.method, "", { message: "Success" });

          return res.json({ message: "Success" });
        });
      });
    });
  } catch (e) {
    console.log("send message error ", e);
    return res.status(500).json({ status: false, message: "something wrong" });
  }
};

const messageReceived = (req, res) => {
  try {
    const { id, receivedAt } = req.body;

    Message.findByIdAndUpdate(id, {
      $set: { receivedAt: receivedAt },
    }).exec((error, updatedData) => {
      if (error) console.log("update error ", error);

      PendingMessage.findByIdAndRemove(id, (err, doc) => {
        if (err) console.log("pending delete error ", err);

        const io = req.io;

        User.findById(updatedData.from).then((userData) => {
          const socketId = userData.socketId;

          io.to(socketId).emit("messageReceived", {
            messageId: id,
            receivedAt: receivedAt,
          });

          console.log(req.url, " ", req.method, "", { message: "Success" });

          return res.json({ message: "Success" });
        });
      });
    });
  } catch (e) {
    console.log("receive message error ", e);
    return res.status(500).json({ status: false, message: "something wrong" });
  }
};

const messageOpened = (req, res) => {
  try {
    const { id, openedAt } = req.body;

    Message.findByIdAndUpdate(id, {
      $set: { openedAt: openedAt },
    }).exec((error, updatedData) => {
      if (error) console.log("update error ", error);

      const io = req.io;

      User.findById(updatedData.from).then((userData) => {
        const socketId = userData.socketId;

        io.to(socketId).emit("messageOpened", {
          messageId: id,
          openedAt: openedAt,
        });

        console.log(req.url, " ", req.method, "", { message: "Success" });

        return res.json({ message: "Success" });
      });
    });
  } catch (e) {
    console.log("OpenedAt message error ", e);
    return res.status(500).json({ status: false, message: "something wrong" });
  }
};

module.exports = {
  sendMessage,
  messageReceived,
  messageOpened,
};
