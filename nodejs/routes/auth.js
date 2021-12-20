const router = require("express").Router();

const controller = require("../controller/auth_controller");

router.post("/user", controller.createUser);

module.exports = router;
