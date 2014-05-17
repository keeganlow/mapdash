WorldMap = Backbone.View.extend
  initialize: () ->
    this.initDataMap()
    this.listenTo(this.collection, 'add', this.addOrder)

  addOrder: (order) ->
    # the datamap takes an array of arcs and handles the logic of determining
    # which ones to draw - it acts as an additional layer of view logic
    #this.removeOrdersOlderThan(timeNow() - prettyArcOptions.arcFadeTime)
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
        # TODO: make this hex value an applevel const
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
    this.dataMap.addPlugin('prettyArc', DatamapsPlugins.handlePrettyArc)
