/**
 * app.js
 *
 * This file contains some conventional defaults for working with Socket.io + Sails.
 * It is designed to get you up and running fast, but is by no means anything special.
 *
 * Feel free to change none, some, or ALL of this file to fit your needs!
 */

// TODO: single quotes everywhere
(function (io) {

  // as soon as this file is loaded, connect automatically, 
  var socket = io.connect();
  if (typeof console !== 'undefined') {
    //log('Connecting to Sails.js...');
  }

  socket.on('connect', function socketConnected() {

    // "subscribe" to order updates
    // TODO: the SailsCollection should really do this itself
    socket.get('/order');

    // TODO: dev only - remove
    $('#addRandomOrder').click(function() {
      createRandomOrder();
      return false;
    });

    function createRandomOrder() {
      var long = getRandomInRange(-180, 180), lat = getRandomInRange(-90, 90);
      var sanfrancisco = new LatLong(37.7833, -122.4167);
      var sfLong = getRandomInRange(-122.391103, -122.511609);
      var sfLat = getRandomInRange(37.740599, 37.793946);

      var newOrder = {
        placedAtTime: new Date().getTime(),
        origin: { latitude: sfLat, longitude: sfLong },
        destination: { latitude: lat, longitude: long }
      };

      // backbone goooo!!!
      orders.create(newOrder, { wait: true });

    }

    // Listen for Comet messages from Sails
    socket.on('message', function messageReceived(message) {

      if (message.model === 'order' && message.verb === 'create') {
        //console.log('new order created', message, message.data);
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
