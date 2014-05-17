// TODO: USA only version - that doesn't break with international arcs!!
var prettyArcOptions = {
  animationSpeed: 600,
  arcFadeTime: 10000,
  arcSharpness: 1,
  strokeColor: '#333333',
  strokeWidth: 2
};

///// TEMP HELPERS

var orders = new MapDash.collections.OrderCollection;

var worldMap = new MapDash.views.WorldMap({
  collection: orders,
  id: 'world-map'
});

var heatMap = new MapDash.views.HeatMap({
  collection: orders,
  id: 'heat-map'
});
