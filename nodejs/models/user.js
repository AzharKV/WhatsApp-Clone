const mongoose = require("mongoose");

const moment = require("moment");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  imagePath: {
    type: String,
    required: false,
  },
  about: {
    type: String,
    required: true,
  },
  lastSeen: { type: Date, default: moment().format(), required: false },
  status: {
    type: Boolean,
    default: false,
    required: false,
  },
  socketId: {
    type: String,
    default: "",
    required: false,
  },
});

mongoose.model("User", userSchema);
