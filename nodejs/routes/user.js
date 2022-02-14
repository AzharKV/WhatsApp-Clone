const router = require("express").Router();

const controller = require("../controller/user_controller");

const auth = require("../middleware/api_auth");

//user list
router.get("/getUsers", auth, controller.getUsers);

//user status
router.get("/userStatus/:id", auth, controller.userStatus);

//check user exist
router.get("/accountExist/:phone", auth, controller.accountExist);

module.exports = router;
