// TODO: USA only version - that doesn't break with international arcs!!
var prettyArcOptions = {
  animationSpeed: 600,
  arcFadeTime: 10000,
  arcSharpness: 1,
  strokeColor: '#333333',
  strokeWidth: 2
};

///// TEMP HELPERS
function getRandomInRange(from, to, fixed) {
  fixed = fixed || 3;
  return (Math.random() * (to - from) + from).toFixed(fixed) * 1;
}

function timeNow() { return (new Date().getTime()); }

//function getRandomOrder() {
  //// anywhere in the world
  //var long = getRandomInRange(-180, 180),
      //lat = getRandomInRange(-90, 90),
      //sfLong = getRandomInRange(-122.391103, -122.511609),
      //sfLat = getRandomInRange(37.740599, 37.793946);

  //console.log(sfLat, sfLong);

  //// somewhere in SF(ish)
  ////sf lat: 37.740599, 37.793946
        ////long:  -122.391103, -122.511609

  //var order = new Order({
    //placedAtTime: new Date().getTime(),
    ////originLatLong: new LatLong(37.7833, -122.4167),
    //originLatLong: new LatLong(sfLat, sfLong),
    //destinationLatLong: new LatLong(lat, long)
  //});

  //return order;
//}

function LatLong(lat, long) {
  if (Math.abs(lat) > 90) {
    throw "lat must be between -90 and 90";
  }
  if (Math.abs(long) > 180) {
    throw "long must be between -180 and 180";
  }
  this.lat = lat;
  this.long = long;
}

var orders = new OrderCollection;

// TODO: consider moving to the class itself
// the collection should remove arcs that are no longer visible
orders.on("add", function (newOrder) {
  var i, deleteUntilIndex, order;
  console.log('added order', order, this);
  // when a new item is added to the collection - remove old expired items,
  // then update the ui remove hidden arcs from the dom
  for (i = 0; i < this.models.length; i += 1) {
    order = this.models[i];

    if (order.attributes.placedAtTime < (timeNow() - prettyArcOptions.arcFadeTime)) {
      deleteUntilIndex = i
    } else {
      // this optimization assumes that orders are sorted from oldest to newest
      break;
      // first arg to slice represents the first element in to keep in the result
    }
  }
  if (deleteUntilIndex > -1) {
    this.models = this.models.slice(deleteUntilIndex + 1);
  }
});

var worldMap = new WorldMap({
  collection: orders,
  id: 'world-map'
});

var heatMap = new HeatMap({
  collection: orders,
  id: 'heat-map'
});
