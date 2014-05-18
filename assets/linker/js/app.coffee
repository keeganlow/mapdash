
orders   = new MapDash.collections.OrderCollection
do (io = window.io) ->

  heatMap  = new MapDash.views.HeatMap  collection: orders, id: 'heat-map'
  worldMap = new MapDash.views.WorldMap collection: orders, id: 'world-map'

  socket = io.connect()

  socket.on 'connect', ->
    log 'Socket now connected.'

    $('.map').click ->
      orders.createRandomOrder()
      false

    $('#new-order').submit ->
      orderProperties = 
        placedAtTime: _.now()
        origin:
          address: $(this).find('#origin-address').val()
        destination:
          address: $(this).find('#destination-address').val()
      orders.create orderProperties, wait: true
      false

    # Listen for Comet messages from Sails
    socket.on 'message', (message) ->
      if message.model is 'order' and message.verb is 'create'
        order = message.data
        log 'new order!', order


  # Expose connected `socket` instance globally so that it's easy
  # to experiment with from the browser console while prototyping.
  window.socket = socket

  # Simple log function to keep the example simple
  log = ->
    if typeof console isnt 'undefined'
      console.log.apply console, arguments

