const router = require("express").Router();

const controller = require("../controller/message_controller");

const auth = require("../middleware/api_auth");

//sendMessage
router.post("/sendMessage", auth, controller.sendMessage);

module.exports = router;
