# TODO: update the heatmap when new orders created
# TODO: removing expired orders from the orders collection should use the
# "remove" method - this will fire remove events on the collection that
# this view can listen for and update the maps MVC object accordingly
HeatMap = Backbone.View.extend
  initialize: () ->
    this.initHeatMap()
    this.listenTo(this.collection, 'add', this.addOrder)

  initHeatMap: () ->
    orderToOriginLatLng = (order) ->
      new google.maps.LatLng(order.origin.lat, origin.origin.long)

    originLatLngs = _.map(this.collection.models, orderToOriginLatLng)

    # TODO: these options should be passed in
    mapOptions =
      zoom: 13,
      center: new google.maps.LatLng(37.774546, -122.433523),
      mapTypeId: google.maps.MapTypeId.SATELLITE

    # TODO: use this.id for selector
    this.googleMap = new google.maps.Map(document.getElementById('heat-map'), mapOptions);

    # TODO: comment about this
    # TODO: better variable name than pointArray
    this.pointArray = new google.maps.MVCArray(originLatLngs);

    heatmap = new google.maps.visualization.HeatmapLayer
      data: this.pointArray

    heatmap.setMap(this.googleMap)

  addOrder: (order, orders) ->
    #console.log 'HeatMap addOrder order',  order
    #console.log 'HeatMap addOrder orders',  orders
    orderOrigin = order.get('origin')
    console.log orderOrigin
    originLatLng = new google.maps.LatLng(orderOrigin.latitude, orderOrigin.longitude)
    this.pointArray.push(originLatLng)
