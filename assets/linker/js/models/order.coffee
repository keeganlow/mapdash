define [ 'underscore', 'backbone', 'config'], (_, Backbone, config) ->
  Backbone.Model.extend
    urlRoot: '/order',
    initialize: (order) ->
      this.on('add', this.scheduleExpiration)
      this.on('remove', this.cancelExpiration)

    # if the order is removed before its expiration timer completes, there's no
    # need to maintain the expiration timer.
    cancelExpiration: ->
      if this.expirationTimeout then clearTimeout(this.expirationTimeout)

    # TODO: comment explaining
    scheduleExpiration: (order) ->
      expire = -> order.collection.remove(order)

      # TODO: make fade time an app level const
      this.expirationTimeout = setTimeout expire, config.prettyArcOptions.arcFadeTime


