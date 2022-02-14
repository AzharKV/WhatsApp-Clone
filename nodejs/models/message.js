const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema({
  _id: {
    type: String,
    required: true,
  },
  message: {
    type: String,
    required: true,
  },
  from: {
    type: String,
    required: true,
  },
  to: {
    type: String,
    required: true,
  },
  messageType: {
    type: String,
    required: false,
  },
  filePath: {
    type: String,
    required: false,
  },
  createdAt: { type: Date, required: true },
  receivedAt: { type: Date, required: false },
  openedAt: { type: Date, required: false },
});

mongoose.model("Message", messageSchema);
