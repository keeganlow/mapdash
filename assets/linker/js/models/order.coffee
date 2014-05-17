OrderModel = Backbone.Model.extend
  urlRoot: '/order',
  initialize: (order) ->
    this.on('add', this.scheduleExpiration)

  # in this application, the views both require 
  scheduleExpiration: (order) ->
    expire = () -> order.collection.remove(order)

    # TODO: make fade time an app level const
    setTimeout expire, prettyArcOptions.arcFadeTime


