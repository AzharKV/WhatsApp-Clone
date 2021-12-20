const mongoose = require("mongoose");

const User = mongoose.model("User");

const jwt = require("jsonwebtoken");
const key = require("../key");

const createUser = (req, res) => {
  const { name, imageUrl, status, lastSeen, about, phone } = req.body;

  let errorMap = {};

  if (!name || !imageUrl || !status || !lastSeen || !about || !phone) {
    errorMap.error = "Please input all fields";
    if (!name) errorMap.name = "name is required";
    if (!imageUrl) errorMap.imageUrl = "imageUrl is required";
    if (!status) errorMap.status = "status is required";
    if (!lastSeen) errorMap.lastSeen = "lastSeen is required";
    if (!about) errorMap.about = "about is required";
    if (!phone) errorMap.phone = "phone is required";
    return res.status(422).json(errorMap);
  }

  User.findOne({ phone: phone })
    .select("-__v")
    .then((savedUser) => {
      if (savedUser) {
        const token = jwt.sign({ _id: savedUser._id }, key.JWT_SECRET);
        return res.json({
          message: "User is already exist",
          token,
          user: savedUser,
        });
      }

      const user = new User({
        name,
        imageUrl,
        status,
        lastSeen,
        about,
        phone,
      });

      user.save().then((user) => {
        const token = jwt.sign({ _id: user._id }, key.JWT_SECRET);

        res.json({ message: "Saved Successfully", token, user: user });
      });
    });
};

module.exports = {
  createUser,
};
