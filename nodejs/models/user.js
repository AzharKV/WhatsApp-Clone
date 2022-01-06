const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  imageUrl: {
    type: String,
    required: true,
  },
  about: {
    type: String,
    required: true,
  },
  lastSeen: { type: Date, default: Date.now },
  status: {
    type: Boolean,
  },
  socketId: {
    type: String,
  },
});

mongoose.model("User", userSchema);
