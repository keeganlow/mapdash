/**
 * app.js
 *
 * This file contains some conventional defaults for working with Socket.io + Sails.
 * It is designed to get you up and running fast, but is by no means anything special.
 *
 * Feel free to change none, some, or ALL of this file to fit your needs!
 */
(function (io) {

  var socket = io.connect();

  socket.on('connect', function socketConnected() {

    // TODO: dev only - remove
    $('body').click(function() {
      orders.createRandomOrder();
      return false;
    });

    // Listen for Comet messages from Sails
    socket.on('message', function messageReceived(message) {

      if (message.model === 'order' && message.verb === 'create') {
        var order = message.data;
      }
    });

    ///////////////////////////////////////////////////////////
    // Here's where you'll want to add any custom logic for
    // when the browser establishes its socket connection to 
    // the Sails.js server.
    ///////////////////////////////////////////////////////////
    log(
      'Socket is now connected and globally accessible as `socket`.\n' + 
      'e.g. to send a GET request to Sails, try \n' + 
      '`socket.get("/", function (response) ' +
      '{ console.log(response); })`'
    );
    ///////////////////////////////////////////////////////////

  });


  // Expose connected `socket` instance globally so that it's easy
  // to experiment with from the browser console while prototyping.
  window.socket = socket;


  // Simple log function to keep the example simple
  function log () {
    if (typeof console !== 'undefined') {
      console.log.apply(console, arguments);
    }
  }


})(window.io);
