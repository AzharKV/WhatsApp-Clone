const router = require("express").Router();

const controller = require("../controller/auth_controller");

const auth = require("../middleware/api_auth");

//create user
router.post("/user", controller.createUser);

//create user by phone number
router.post("/userRegistration", controller.userRegistration);

//myData
router.get("/myDetails", auth, controller.myDetails);

module.exports = router;
