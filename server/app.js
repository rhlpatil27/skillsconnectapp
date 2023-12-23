const express = require('express');
const bodyParser = require('body-parser');
const socketio = require('socket.io');
const e = require('express');
var app = express();

const router = require('./router');
app.use(router);

// parse application/x-www-form-urlencoded
// { extended: true } : support nested object
// Returns middleware that ONLY parses url-encoded bodies and 
// This object will contain key-value pairs, where the value can be a 
// string or array(when extended is false), or any type (when extended is true)
app.use(bodyParser.urlencoded({ extended: true }));

//This return middleware that only parses json and only looks at requests where the Content-type
//header matched the type option. 
//When you use req.body -> this is using body-parser cause it is going to parse 
// the request body to the form we want
app.use(bodyParser.json());

var server = app.listen(3000,()=>{
    console.log('Server is running')
})

//Chat Server

var io = socketio.listen(server)
const users = {}; // Object to store user-specific data (user ID to socket ID mapping)

io.on('connection',function(socket) {

    //The moment one of your client connected to socket.io server it will obtain socket id
    //Let's print this out.
    console.log(`Connection : SocketId = ${socket.id}`)
    // for storing userid to socket id
    //start-->
     socket.on('store_user_id', function(userID) {
              console.log(`store_user_id = ${userID}`)
              users[userID] = socket.id; // Store user ID and socket ID mapping
          })
     //<--end
    //start-->
        socket.on('send_message', (message) => {
        console.log('send_message->')
        console.log(message)
          const receiverSocketId = users[message.to_user_id];
          console.log('receiverSocketId->')
          console.log(receiverSocketId)
          if(receiverSocketId){
               console.log('event emit true')
              io.to(receiverSocketId).emit('receive_message', JSON.stringify(message));
          }else{
              // Handle scenarios where the receiver's socket ID is not available (e.g., offline user)
               console.log('event emit false')
          }
        });

       socket.on('send_message', (message) => {
        console.log('send_message->')
        console.log(message)
          const receiverSocketId = users[message.to_user_id];
          console.log('receiverSocketId->')
          console.log(receiverSocketId)
          if(receiverSocketId){
               console.log('event emit true')
              io.to(receiverSocketId).emit('receive_message', JSON.stringify(message));
          }else{
              // Handle scenarios where the receiver's socket ID is not available (e.g., offline user)
               console.log('event emit false')
          }
        });
    socket.on('disconnect', function () {
        console.log("One of sockets disconnected from our server.")
         // Clean up user-specific data upon disconnection
          for (const userID in users) {
            if (users[userID] === socket.id) {
              delete users[userID];
              break;
            }
          }
    });
})

module.exports = server; //Exporting for test