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
    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  User.findOne({ phone: phone })
    .select("-__v")
    .then((savedUser) => {
      if (savedUser) {
        const token = jwt.sign({ _id: savedUser._id }, key.JWT_SECRET);

        const result = {
          message: "User is already exist",
          token,
          user: savedUser,
        };

        console.log(req.url, " ", req.method, "", result);

        return res.json(result);
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

        const result = { message: "Saved Successfully", token, user: user };

        console.log(req.url, " ", req.method, "", result);

        res.json(result);
      });
    });
};

const myDetails = (req, res) => {
  const result = {
    id: req.user._id,
    name: req.user.name,
    imageUrl: req.user.imageUrl,
    about: req.user.about,
  };

  console.log(req.url, " ", req.method, "", req.user);
  res.json(result);
};

module.exports = {
  createUser,
  myDetails,
};
