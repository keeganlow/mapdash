hasCoordinates = (req, res, next) ->

  # 1. has lat long data already
  return next() if hasCoordinatesInReq(req)

  # 2. has address we can try to geocode
  geocoderProvider = 'google'
  httpAdapter = 'http'

  extra = {}
  geocoder = require('node-geocoder').getGeocoder(geocoderProvider, httpAdapter, extra)

  # an array containing 'origin', 'destination', or both
  pointsToGeocode = pointsWithoutCoordinates(req)

  geocoder.geocode(req.body[pointsToGeocode[0]].address)
    .then (googleRes) ->
      req.body[pointsToGeocode[0]].latitude = googleRes[0].latitude
      req.body[pointsToGeocode[0]].longitude = googleRes[0].longitude
      googleRes
    .then () ->
      return if pointsToGeocode.length is 1
      geocoder.geocode(req.body[pointsToGeocode[1]].address)
        .then (googleRes) ->
          req.body[pointsToGeocode[1]].latitude = googleRes[0].latitude
          req.body[pointsToGeocode[1]].longitude = googleRes[0].longitude
    .fin -> next()
    .catch (err) -> console.log 'err', err

  # 3. has neither - defer to model validations to handle this

pointsWithoutCoordinates = (req) ->
  points = []
  origin = req.body.origin
  destination = req.body.destination
  if origin.address? and !origin.latitude? and !origin.longitude?
    points.push 'origin'
  if destination.address? and !destination.latitude? and !destination.longitude?
    points.push 'destination'

  points

hasCoordinatesInReq = (req) ->
  origin = req.body.origin
  destination = req.body.destination
  destination.latitude? and destination.longitude? and origin.latitude? and origin.longitude?

module.exports = hasCoordinates
