module.exports = (socket) => {
  socket.on("/test", function (msg) {
    console.log(msg);
    var newString = 1 + msg;

    socket.emit("/test", newString);
    newString = +1;

    //console.log("data from middleware ", socket.data);
  });
};
