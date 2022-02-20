const router = require("express").Router();

const controller = require("../controller/user_controller");

const auth = require("../middleware/api_auth");

//user list
router.get("/getUsers", auth, controller.getUsers);

//get user details
router.get("/user/:phone", auth, controller.getUserDetails);

//get user status
router.get("/userStatus/:id", auth, controller.userStatus);

//update user status
router.put("/userStatus", auth, controller.updateUserStatus);

module.exports = router;
