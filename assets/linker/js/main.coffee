requirejs.config
    waitSeconds: 5
    baseUrl: 'linker/js'
    paths:
      underscore: 'libs/underscore'
      jquery: 'libs/jquery'
      backbone: 'libs/backbone'
      socketio: 'libs/socket.io'
      sailsio: 'libs/sails.io'
      d3: 'libs/d3.v3.min'
      datamaps: 'libs/datamaps.all'
      'datamaps.prettyarc': 'libs/datamaps.prettyarc',
      async: '/linker/bower_components/requirejs-plugins/src/async'
      topojson: 'libs/topojson.v1.min'
    shim:
      underscore:
        exports: '_'
      jquery:
        exports: '$'
      backbone:
        deps: ['underscore', 'jquery']
        exports: 'Backbone'
      sailsio:
        deps: ['socketio']
        exports: 'io'

requiredModules = [
  'jquery',
  'underscore'
  'sailsio'
  'backbone'
  'collections/orders'
  'views/heatmap'
  'views/worldmap'
]

require requiredModules, ($, _, io, Backbone, OrderCollection, HeatMap, WorldMap) ->

  # Simple log function to keep the example simple
  log = ->
    console.log.apply console, arguments if typeof console isnt 'undefined'

  # expose the orders collection for console-based experimentation
  orders = window.orders = new OrderCollection
  heatMap  = new HeatMap collection: orders, id: 'heat-map'
  worldMap = new WorldMap collection: orders, id: 'world-map'

  socket = io.connect()

  socket.on 'connect', ->
    log 'Socket now connected.'

    $('#world-map').click ->
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

    true
