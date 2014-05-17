$(function() {

  function initializeHeatmap() {
    var taxiData = [
      //new google.maps.LatLng(37.782551, -122.445368),
      //new google.maps.LatLng(37.782745, -122.444586),
      //new google.maps.LatLng(37.782842, -122.443688),
      //new google.maps.LatLng(37.782919, -122.442815),
      //new google.maps.LatLng(37.782992, -122.442112),
      //new google.maps.LatLng(37.783100, -122.441461),
      //new google.maps.LatLng(37.783206, -122.440829),
      //new google.maps.LatLng(37.783273, -122.440324),
      //new google.maps.LatLng(37.783316, -122.440023),
      //new google.maps.LatLng(37.783357, -122.439794),
      //new google.maps.LatLng(37.783371, -122.439687),
    ];
    var mapOptions = {
      zoom: 13,
      center: new google.maps.LatLng(37.774546, -122.433523),
      mapTypeId: google.maps.MapTypeId.SATELLITE
    };

    var map = new google.maps.Map(document.getElementById('heat-map'), mapOptions);

    var pointArray = new google.maps.MVCArray(taxiData);

    var heatmap = new google.maps.visualization.HeatmapLayer({
      data: pointArray
    });

    heatmap.setMap(map);
  }

  //google.maps.event.addDomListener(window, 'load', initializeHeatmap);
});
