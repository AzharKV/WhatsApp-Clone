const mongoose = require("mongoose");

const pendingMessageSchema = new mongoose.Schema({
  _id: {
    type: String,
    required: true,
  },

  toUserId: {
    type: String,
    required: true,
  },
});

mongoose.model("PendingMessage", pendingMessageSchema);
