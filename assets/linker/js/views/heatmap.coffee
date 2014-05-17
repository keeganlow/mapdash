MapDash = {} unless MapDash?
MapDash.views = {} unless MapDash.views?

MapDash.views.HeatMap = Backbone.View.extend
  initialize: ->
    this.initHeatMap()
    this.listenTo(this.collection, 'add', this.addOrder)
    this.listenTo(this.collection, 'remove', this.removeOrder)

  removeOrder: (order, orders, options) ->
    this.pointArray.removeAt(options.index)

  initHeatMap: ->
    orderToOriginLatLng = (order) ->
      new google.maps.LatLng(order.origin.lat, origin.origin.long)

    originLatLngs = _.map(this.collection.models, orderToOriginLatLng)

    this.googleMap = new google.maps.Map(document.getElementById(this.id),
      MapDash.config.googleMapOptions)

    # TODO: comment about this
    # TODO: better variable name than pointArray
    this.pointArray = new google.maps.MVCArray(originLatLngs)

    heatmap = new google.maps.visualization.HeatmapLayer
      data: this.pointArray

    heatmap.setMap(this.googleMap)

  addOrder: (order, orders) ->
    orderOrigin = order.get('origin')
    originLatLng = new google.maps.LatLng(orderOrigin.latitude, orderOrigin.longitude)
    this.pointArray.push(originLatLng)
