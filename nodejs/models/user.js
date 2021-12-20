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
  lastSeen: {
    type: String,
    required: true,
  },
  status: {
    type: Boolean,
    required: true,
  },
});

mongoose.model("User", userSchema);
