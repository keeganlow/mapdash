# modified version of http://snazzymaps.com/style/25/blue-water
blueWaterMapStyle = [{"featureType":"water","stylers":[{"color":"#b3d4fc"},{"visibility":"on"}]},{"featureType":"landscape","stylers":[{"color":"#f2f2f2"}]},{"featureType":"road","stylers":[{"saturation":-100},{"lightness":45}]},{"featureType":"road.highway","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#444444"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]}]

HeatMap = Backbone.View.extend
  initialize: () ->
    this.initHeatMap()
    this.listenTo(this.collection, 'add', this.addOrder)
    this.listenTo(this.collection, 'remove', this.removeOrder)

  removeOrder: (order, orders, options) ->
    this.pointArray.removeAt(options.index)

  initHeatMap: () ->
    orderToOriginLatLng = (order) ->
      new google.maps.LatLng(order.origin.lat, origin.origin.long)

    originLatLngs = _.map(this.collection.models, orderToOriginLatLng)

    # TODO: these options should be passed in
    mapOptions =
      zoom: 12,
      center: new google.maps.LatLng(37.774546, -122.433523),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      styles: blueWaterMapStyle,
      mapTypeControlOptions:
        mapTypeIds: []

    # TODO: use this.id for selector
    this.googleMap = new google.maps.Map(document.getElementById('heat-map'), mapOptions);


    # TODO: comment about this
    # TODO: better variable name than pointArray
    this.pointArray = new google.maps.MVCArray(originLatLngs);

    heatmap = new google.maps.visualization.HeatmapLayer
      data: this.pointArray

    heatmap.setMap(this.googleMap)

  addOrder: (order, orders) ->
    orderOrigin = order.get('origin')
    originLatLng = new google.maps.LatLng(orderOrigin.latitude, orderOrigin.longitude)
    this.pointArray.push(originLatLng)
