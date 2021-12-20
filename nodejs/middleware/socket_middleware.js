module.exports = (socket, next) => {
  if (socket.handshake.auth.token == "123") {
    socket.data = {
      token: socket.handshake.auth.token,
    };

    next();
  } else {
    console.log("else");

    const err = new Error("not authorized");
    err.data = { content: "Please retry later" };
    next(err);
  }
};
