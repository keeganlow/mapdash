// TODO: USA only version - that doesn't break with international arcs!!
var map = new Datamap({
  scope: 'world',
  //scope: 'usa',
  element: document.getElementById('container1'),
  projection: 'mercator',
  fills: {
    defaultFill: '#b3d4fc',
  },

  geographyConfig: {
    hideAntarctica: true,
    borderWidth: 1,
    borderColor: '#FDFDFD',
    popupTemplate: function(geography, data) {
      return '<div class="hoverinfo"><strong>' + geography.properties.name + '</strong></div>';
    },
    popupOnHover: true,
    highlightOnHover: true,
    highlightFillColor: '#b3d4fc',
    highlightBorderColor: 'rgba(2, 114, 150, 0.2)',
    highlightBorderWidth: 2
  },
});

map.addPlugin("prettyArc", DatamapsPlugins.handlePrettyArc);


///// TEMP HELPERS
function getRandomInRange(from, to, fixed) {
  fixed = fixed || 3;
  return (Math.random() * (to - from) + from).toFixed(fixed) * 1;
}

//function getRandomArc() {
function getRandomOrder() {
  var long = getRandomInRange(-180, 180),
      lat = getRandomInRange(-90, 90);

  var order = new Order({
    placedAtTime: new Date().getTime(),
    originLatLong: new LatLong(37.7833, -122.4167),
    destinationLatLong: new LatLong(lat, long)
  });

  return order;
}

function addRandomOrder(map) {
  addOrder(map, getRandomOrder());
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

function Order(properties) {
  this.placedAtTime = properties.placedAtTime;
  this.originLatLong = properties.originLatLong;
  this.destinationLatLong = properties.destinationLatLong;
}

Order.prototype.toArc = function () {
  // TODO: review - why don't we need that = this in .. this case?
  return {
    origin: { 
      latitude: this.originLatLong.lat,
      longitude: this.originLatLong.long
    },
    destination: {
      latitude: this.destinationLatLong.lat,
      longitude: this.destinationLatLong.long
    }
  };
};

Order.prototype.olderThan = function (time) {
  return (this.placedAtTime < time);
}

// TODO: something more elegant than global arcs

var orders = [];

var prettyArcOptions = {
  animationSpeed: 600,
  arcFadeTime: 10000,
  arcSharpness: 1,
  strokeColor: '#333333',
  strokeWidth: 2
};

function timeNow() {
  return (new Date().getTime());
}

var addOrder = function (map, order) {
  var order, i, deleteUntilIndex;
  orders.push(order);

  console.log('orders', orders)

  // TODO: move this step to its own method
  // remove hidden arcs from the dom
  for (i = 0; i < orders.length; i += 1) {
    order = orders[i];
    //console.log('placedat', order.placedAtTime, 'must be new than', timeNow() - prettyArcOptions.arcFadeTime)
    if (order.olderThan(timeNow() - prettyArcOptions.arcFadeTime)) {
      //console.log('removing', order)
      deleteUntilIndex = i;
    } else {
      //console.log('break', order)
      // this optimization assumes that orders are order from oldest to newest
      break;
    }
  }
  // first arg to slice represents the first element in to keep in the result
  console.log('orders', orders)
  if (deleteUntilIndex > -1) {
    console.log('deleteUntilIndex', deleteUntilIndex)
    console.log('removing the following orders from map', orders.slice(0, deleteUntilIndex));
    orders = orders.slice(deleteUntilIndex + 1);
  }

  var arcs = _.map(orders, function (order) { return order.toArc() });
  //console.log(arcs);
  console.log('pre arc push - dom arc count', d3.selectAll('path.datamaps-prettyarc').size())
  map.prettyArc(arcs, prettyArcOptions);
  console.log('post arc push - dom arc count', d3.selectAll('path.datamaps-prettyarc').size())
  // TODO: figure out why:
  //       orders is trimmed, prettyArc is called with reduced set of orders, dom count of
  //       arc paths doesn't  change until... prettyArc is called _again_
  //       unless...selectAll().size() doesn't do what it should be doing...
};
