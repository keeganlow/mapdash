define [
  'underscore',
  'backbone',
  'config',
  'd3',
  'datamaps',
  'datamaps.prettyarc'
], (_, Backbone, config, d3, DataMap, handlePrettyArc) ->
  WorldMap = Backbone.View.extend
    initialize: ->
      this.initDataMap()
      this.listenTo this.collection, 'add', this.updateMap
      this.listenTo this.collection, 'remove', this.updateMap

    updateMap: ->
      # the datamap takes an array of arcs and handles the logic of determining
      # which ones to draw - it acts as an additional layer of view logic
      this.dataMap.prettyArc this.collection.toJSON(), config.prettyArcOptions

      # countDomArcs = ->
      #   arcCount = d3.selectAll('path.datamaps-prettyarc').size()
      #   console.log('current DOM arc count', arcCount)
      # setTimeout countDomArcs, 700

    initDataMap: ->
      this.dataMap = new DataMap config.dataMapOptions
      this.dataMap.addPlugin 'prettyArc', handlePrettyArc
