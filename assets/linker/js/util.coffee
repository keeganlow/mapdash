# Miscellaneous utility functions used by the MapDash app.

define [ 'underscore', 'backbone'], (_, Backbone) ->
  do ->
    getRandomInRange = (from, to, digits) ->
      digits ?= 3
      Number(Math.random() * (to - from) + from).toFixed(digits)

    LatLong = (lat, long) ->
      if (Math.abs(lat) > 90) then throw 'lat must be between -90 and 90'
      if (Math.abs(long) > 180) then throw 'long must be between -180 and 180'
      this.lat = lat
      this.long = long

    getRandomInRange: getRandomInRange
    LatLong: LatLong
