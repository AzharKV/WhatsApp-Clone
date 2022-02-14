const router = require("express").Router();

const controller = require("../controller/message_controller");

const auth = require("../middleware/api_auth");

//sendMessage
router.post("/sendMessage", auth, controller.sendMessage);

//messageReceived
router.put("/receivedMessageUpdate", auth, controller.messageReceived);

//messageOpened
router.put("/openedMessageUpdate", auth, controller.messageOpened);

module.exports = router;
