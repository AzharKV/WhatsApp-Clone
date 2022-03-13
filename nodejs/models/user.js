const mongoose = require("mongoose");

const moment = require("moment");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: false,
  },
  phoneNumber: {
    type: String,
    required: true,
  },
  phoneWithDialCode: {
    type: String,
    required: true,
  },
  dialCode: {
    type: String,
    required: true,
  },
  image: {
    type: String,
    required: false,
  },
  about: {
    type: String,
    required: false,
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
