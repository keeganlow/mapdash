# Presentation config options for the MapDash app.
MapDash = {} unless MapDash?
MapDash.config = do ->
  prettyBlue = '#b3d4fc'

  # in realtime mode, the number of milliseconds to display an order before
  # hiding it
  orderDisplayTTL = 10000

  prettyBlue: prettyBlue
  orderDisplayTTL: orderDisplayTTL
  prettyArcOptions:
    animationSpeed: 600
    arcFadeTime: orderDisplayTTL
    arcSharpness: 1
    strokeColor: '#333333'
    strokeWidth: 2
  dataMapOptions:
    scope: 'world'
    element: document.getElementById('world-map')
    projection: 'mercator'
    fills:
      defaultFill: '#ececec'
    geographyConfig:
      hideAntarctica: true
      borderWidth: 1
      borderColor: '#cccccc'
      popupOnHover: false
      highlightOnHover: false
      highlightFillColor: prettyBlue
      highlightBorderColor: 'rgba(2, 114, 150, 0.2)'
      highlightBorderWidth: 2
  googleMapOptions:
    zoom: 12
    center: new google.maps.LatLng(37.774546, -122.433523)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControlOptions:
      mapTypeIds: []
    # modified version of http://snazzymaps.com/style/25/blue-water
    styles: [{'featureType':'water','stylers':[{'color':prettyBlue},{'visibility':'on'}]},{'featureType':'landscape','stylers':[{'color':'#f2f2f2'}]},{'featureType':'road','stylers':[{'saturation':-100},{'lightness':45}]},{'featureType':'road.highway','stylers':[{'visibility':'simplified'}]},{'featureType':'road.arterial','elementType':'labels.icon','stylers':[{'visibility':'off'}]},{'featureType':'administrative','elementType':'labels.text.fill','stylers':[{'color':'#444444'}]},{'featureType':'transit','stylers':[{'visibility':'off'}]},{'featureType':'poi','stylers':[{'visibility':'off'}]}]
