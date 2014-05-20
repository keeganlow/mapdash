# MapDash
### What is MapDash?

MapDash is a realtime dashboard that shows:

1. A heatmap of the pickup distribution in San Francisco
2. A world map showing where recent pickups are headed

MapDash defines a TTL for each order, after which it will be removed from the UI. Twenty-four hours might be a nice value to start with; for demostration purposes, this value is currently set to 100 seconds. The variable in question is orderDisplayTTL in assets/linker/js/config.coffee.

Without much additional work, MapDash could be extended to have a non-realtime mode where this TTL would not be used. In this future version, users could specifiy a start and end time. MapDash would then show data for all orders placed during this time span.

### Can I see it in action?

You sure can! Head over to: [map-dash.herokuapp.com](http://map-dash.herokuapp.com/)

This version's UI includes two helpers for sending order create requests to the backend: 

1. Click anywhere on the world map. This will create a random order originating somewhere within SF city limits and destined for a random point on the globe (including the middle of the ocean).
2. Add an origin and destination address to the order creation form. Because the frontend code needs latitude and longitude data to update the map views, the backend will use Google's geocoding API to translate the addresses to coordinate data before notifying the clients of the new order's creation.


### Intended Use

In one potential use case, the service that handles order creation could push order metadata to a message queue, AWS's SNS, or similar. The MapDash backend would in turn consume from this messaging service, create its own order record, and broadcast information about the new order to all listening clients. The benefit of MapDash storing its own copy of the order data is that, in future versions, the UI could be updated to allow a user to specify a certain time range for which to display order data — since this is essentially a reporting query, it would be nice to read from a non-production datastore. Alternatively, these reads could be done off a replicant of the production datastore. 

### Built With
-  [sails.js](http://sailsjs.org)
-  [backbone.js](backbonejs.org)
-  [underscore.js](underscorejs.org)
-  [datamaps](https://github.com/markmarkoh/datamaps)
	- added custom plugin that supports arc fadeouts and "impact" animations
-  [require.js](http://requirejs.org/)
-  [require.js async plugin](https://github.com/millermedeiros/requirejs-plugins)
	- for loading the Google Maps API asynchronously
- [node-geocoder](https://www.npmjs.org/package/node-geocoder)
	- allows the MapDash backend to accept addresses as well as explicit lat/long coordinates

### Future Work

- automated tests for frontend and Sails code
- use a better datastore (not the current in-memory approach)
- turn off public writes
- serverside data validation
- read from queue or notification service
- force HTTPS
- require authentication to view dashboard
- UI for "show me orders between time x and y"
- frontend beautification

