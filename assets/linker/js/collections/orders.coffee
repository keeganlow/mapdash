MapDash = {} unless MapDash?
MapDash.collections = {} unless MapDash.collections?

MapDash.collections.OrderCollection = SailsCollection.extend
  sailsCollection: 'order'
  model: MapDash.models.OrderModel

  # Create a new order originating somewhere in SF and destined for anywhere
  # in the world (including the middle of the ocean). This will persist the new
  # order on the backend and trigger an "add" event on the this collection.
  # Handy for development.
  createRandomOrder: ->
      # we're going to call this a few times, cache the method reference
      getRandomInRange = MapDash.util.getRandomInRange
      worldwideLong = getRandomInRange -180, 180
      worldwideLat = getRandomInRange -90, 90
      sfLong = getRandomInRange -122.391103, -122.511609
      sfLat = getRandomInRange 37.740599, 37.793946

      newOrder =
        placedAtTime: _.now(),
        origin:
          latitude: sfLat,
          longitude: sfLong
        destination:
          latitude: worldwideLat,
          longitude: worldwideLong

      this.create newOrder, wait: true
