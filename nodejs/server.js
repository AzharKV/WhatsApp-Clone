const bodyParser = require("body-parser");
const express = require("express");
const app = express();
const multer = require("multer")();

const http = require("http").createServer(app);
const io = require("socket.io")(http);

const mongoose = require("mongoose");
const key = require("./key");
const userController = require("./controller/user_controller");

//mongoose connection
mongoose.connect(key.MONGO_URL, {
  useNewUrlParser: true,
});

mongoose.connection.on("connected", () => console.log("Connected to mongodb"));

mongoose.connection.on("error", (err) =>
  console.log("Error on connection", err)
);

app.use(express.json());
app.use(multer.array());

app.use(bodyParser.urlencoded({ extended: true }));

//api routes
app.use(require("./routes/auth"));

//invalid api
app.get("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url);
  res.status(401).json({ error: "Invalid Request" });
});

app.post("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url);
  res.status(401).json({ error: "Invalid Request" });
});

app.delete("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url);
  res.status(401).json({ error: "Invalid Request" });
});

app.put("*", (req, res) => {
  console.log("invalid request ", req.method, " ", req.url);
  res.status(401).json({ error: "Invalid Request" });
});

//socket middleware
io.use(require("./middleware/socket_auth"));

//socket connection
io.on("connection", (socket) => {
  //update user status and socket id
  userController.updateUserStatus(socket);

  socket.on("connect_error", (err) =>
    console.log(`connect_error due to ${err.message}`)
  );

  socket.on("disconnect", () => {
    //update last seen, status, socketId
    userController.disconnectUser(socket);
  });

  //socket connection test
  //socket
  require("./sockets/single_chat")(socket);
});

http.listen(5678, () => console.log("server running..."));
