const router = require("express").Router();

const controller = require("../controller/user_controller");

const auth = require("../middleware/api_auth");

const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: "uploads/images/",
  filename: (req, file, cb) => {
    cb(null, req.user._id + path.extname(file.originalname));
  },
});

const upload = multer({
  storage: storage,
});

//user list
router.get("/getUsers", auth, controller.getUsers);

//get user details
router.get("/user/:phone", auth, controller.getUserDetails);

//get user status
router.get("/userStatus/:id", auth, controller.userStatus);

//update user status
router.put("/userStatus", auth, controller.updateUserStatus);

//profile image upload
router.post(
  "/profileImage",
  auth,
  upload.single("image"),
  controller.uploadProfileImage
);

module.exports = router;
