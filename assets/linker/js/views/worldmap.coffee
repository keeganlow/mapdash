WorldMap = Backbone.View.extend
  initialize: () ->
    this.initDataMap()
    this.listenTo(this.collection, 'add', this.addOrder)

  # TODO: add render method

  # This way arcs that have faded out can be pruned from the DOM
  removeOrdersOlderThan: (timestamp) ->
    # when a new item is added to the collection - remove old expired items,
    # then update the ui remove hidden arcs from the dom
    for order, i in orders.models
      if order.attributes.placedAtTime < timestamp
        deleteUntilIndex = i
      else
        # this optimization assumes that orders are sorted from oldest to newest
        break
      # first arg to slice represents the first element in to keep in the result
    if deleteUntilIndex > -1
      orders.models = orders.models.slice(deleteUntilIndex + 1)

  addOrder: (order) ->
    # the datamap takes an array of arcs and handles the logic of determining
    # which ones to draw - it acts as an additional layer of view logic
    this.removeOrdersOlderThan(timeNow() - prettyArcOptions.arcFadeTime)
    this.dataMap.prettyArc(this.collection.toJSON(), prettyArcOptions)

    callback = () ->
      arcCount = d3.selectAll('path.datamaps-prettyarc').size()
      console.log('pre arc push - dom arc count', arcCount)
    setTimeout callback, 700

  initDataMap: () ->
    this.dataMap = new Datamap
      scope: 'world'
      # scope: 'usa'
      element: document.getElementById('world-map')
      projection: 'mercator'
      fills:
        defaultFill: '#b3d4fc'
      geographyConfig:
        hideAntarctica: true
        borderWidth: 1
        borderColor: '#FDFDFD'
        popupTemplate: (geography, data) ->
          '<div class="hoverinfo"><strong>' + geography.properties.name + '</strong></div>'
        popupOnHover: true
        highlightOnHover: true
        highlightFillColor: '#b3d4fc'
        highlightBorderColor: 'rgba(2, 114, 150, 0.2)'
        highlightBorderWidth: 2
    this.dataMap.addPlugin("prettyArc", DatamapsPlugins.handlePrettyArc)
