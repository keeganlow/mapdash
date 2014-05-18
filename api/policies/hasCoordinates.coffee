# TODO: move geocoder code to a "service"
hasCoordinates = (req, res, next) ->

  # 1. has lat long data already
  return next() if hasCoordinatesInReq(req)

  # 2. has address we can try to geocode
  # origin = req.body.origin
  # destination = req.body.destination
  

  #apiKey = process.env.GOOGLE_API_KEY

  geocoderProvider = 'google'
  httpAdapter = 'http'

  extra = {}
  geocoder = require('node-geocoder').getGeocoder(geocoderProvider, httpAdapter, extra)

  pointsToGeocode = pointsWithoutCoordinates(req)
  console.log 'pointsToGeocode', pointsToGeocode  

  console.log('req.body[pointsToGeocode[0]].address', req.body[pointsToGeocode[0]].address)
  geocoder.geocode(req.body[pointsToGeocode[0]].address)
    .then (res) -> 
      console.log('then res', res)
      req.body[pointsToGeocode[0]].latitude = res[0].latitude
      req.body[pointsToGeocode[0]].longitude = res[0].longitude
      res
    .then (res) ->
      return if pointsToGeocode.length is 1
      geocoder.geocode(req.body[pointsToGeocode[1]].address)
        .then (res) -> 
          console.log('then res 2', res)
          req.body[pointsToGeocode[1]].latitude = res[0].latitude
          req.body[pointsToGeocode[1]].longitude = res[0].longitude
    .fin -> 
      console.log('calling next...')
      console.log('req.body at this point', req.body)
      next()
    .catch (err) ->
      console.log 'err', err


  # 3. has neither - defer to model validations to handle this
  #    TODO: write validations for order model

  # order = req.body
  # console.log 'policy order', order

pointsWithoutCoordinates = (req) ->
  points = []
  origin = req.body.origin
  destination = req.body.destination
  if origin.address? and !origin.latitude? and !origin.longitude?
    points.push 'origin'
  # TODO: dry up
  if destination.address? and !destination.latitude? and !destination.longitude?
    points.push 'destination'

  points

hasCoordinatesInReq = (req) ->
  origin = req.body.origin
  destination = req.body.destination
  destination.latitude? and destination.longitude? and origin.latitude? and origin.longitude?

module.exports = hasCoordinates
