const mongoose = require("mongoose");

const User = mongoose.model("User");

const jwt = require("jsonwebtoken");
const key = require("../key");

const moment = require("moment");

const createUser = (req, res) => {
  const { name, phoneNumber, dialCode } = req.body;

  let errorMap = {};

  if (!name || !dialCode || !phoneNumber) {
    errorMap.error = "Please input all fields";
    if (!name) errorMap.name = "name is required";
    if (!dialCode) errorMap.about = "dial code is required";
    if (!phoneNumber) errorMap.phoneNumber = "phoneNumber is required";
    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  }

  User.findOne({ phoneNumber: phoneNumber })
    .select("-__v")
    .then((savedUser) => {
      if (savedUser) {
        const token = jwt.sign({ _id: savedUser._id }, key.JWT_SECRET);

        const result = {
          message: "User is already exist",
          token,
          user: savedUser,
          createdAt: moment().format(),
        };

        console.log(req.url, " ", req.method, "", result);

        return res.json(result);
      }

      const user = new User({
        name,
        phoneNumber,
        phoneWithDialCode: "+" + dialCode + phoneNumber,
        dialCode,
      });

      user.save().then((user) => {
        const token = jwt.sign({ _id: user._id }, key.JWT_SECRET);

        const result = {
          message: "Created Successfully",
          token,
          user,
          createdAt: moment().format(),
        };

        console.log(req.url, " ", req.method, "", result);

        res.json(result);
      });
    });
};

const myDetails = (req, res) => {
  let imageUrl;
  if (req.user.image != undefined) imageUrl = req.serverIp + req.user.image;

  const result = {
    id: req.user._id,
    name: req.user.name,
    phoneNumber: req.user.phoneNumber,
    phoneWithDialCode: req.user.phoneWithDialCode,
    image: imageUrl,
    dialCode: req.user.dialCode,
    about: req.user.about,
    createdAt: moment().format(),
  };

  console.log(req.url, " ", req.method, " ", result);
  res.json(result);
};

const userRegistration = (req, res) => {
  const { phoneNumber, dialCode } = req.body;

  let errorMap = {};

  if (!phoneNumber || !dialCode) {
    errorMap.error = "Please input all fields";

    if (!phoneNumber) errorMap.phoneNumber = "phoneNumber is required";
    if (!dialCode) errorMap.dialCode = "dial code is required";

    console.log(req.url, " ", req.method, "", errorMap);
    return res.status(422).json(errorMap);
  } else {
    const phoneWithDialCode = "+" + dialCode + phoneNumber;

    User.findOne({ phoneWithDialCode: phoneWithDialCode })
      .select("-__v")
      .then((savedUser) => {
        if (savedUser) {
          const token = jwt.sign({ _id: savedUser._id }, key.JWT_SECRET);

          const result = {
            message: "User is already exist",
            token,
            user: savedUser,
            createdAt: moment().format(),
          };

          console.log(req.url, " ", req.method, "", result);

          return res.json(result);
        } else {
          const user = new User({
            phoneNumber,
            phoneWithDialCode,
            dialCode,
          });

          user.save().then((user) => {
            const token = jwt.sign({ _id: user._id }, key.JWT_SECRET);

            const result = {
              message: "Created Successfully",
              token,
              user,
              createdAt: moment().format(),
            };

            console.log(req.url, " ", req.method, "", result);

            res.json(result);
          });
        }
      });
  }
};

module.exports = {
  createUser,
  userRegistration,
  myDetails,
};
