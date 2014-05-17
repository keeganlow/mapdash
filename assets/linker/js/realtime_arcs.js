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

var worldMap = new WorldMap({
  collection: orders,
  id: 'world-map'
});

var heatMap = new HeatMap({
  collection: orders,
  id: 'heat-map'
});
