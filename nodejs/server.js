const bodyParser = require("body-parser");
const express = require("express");
const app = express();

const multer = require("multer")();

const http = require("http").createServer(app, {
  path: "/open",
});

const io = require("socket.io")(http);

const mongoose = require("mongoose");

const key = require("./key");

//mongoose connection
mongoose.connect(key.MONGO_URL, {
  useNewUrlParser: true,
});

mongoose.connection.on("connected", () => console.log("Connected to mongodb"));

mongoose.connection.on("error", (err) =>
  console.log("Error on connection", err)
);

require("./models/user");

app.use(express.json());
app.use(multer.array());

app.use(bodyParser.urlencoded({ extended: true }));

//api routes
app.use(require("./routes/auth"));

//socket middleware
//io.use(require("./middleware/socket_auth"));

//socket connection
io.on("connection", (socket) => {
  console.log("connection established by ", socket.id);

  const User = mongoose.model("User");

  User.findByIdAndUpdate(socket.data.userId, {
    $set: { socketId: socket.id },
  }).exec((error) => {
    if (error) console.log(error);
  });

  socket.on("connect_error", (err) =>
    console.log(`connect_error due to ${err.message}`)
  );

  socket.on("disconnect", () => {
    console.log("connection closed by ", socket.id);

    User.findByIdAndUpdate(socket.data.userId, { $set: { socketId: "" } }).exec(
      (error) => {
        if (error) console.log(error);
      }
    );
  });

  //socket connection test
  //socket
  require("./sockets/single_chat")(socket);
});

http.listen(5678, () => console.log("connected"));
