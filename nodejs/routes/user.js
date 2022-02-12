const router = require("express").Router();

const controller = require("../controller/user_controller");

const auth = require("../middleware/api_auth");

//userList
router.get("/getUsers", auth, controller.getUsers);

//user_status
router.get("/userStatus/:id", auth, controller.userStatus);

module.exports = router;
