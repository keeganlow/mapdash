# Presentation config options for the MapDash app. 
MapDash = {} unless MapDash?
MapDash.config = do ->

  prettyArcOptions:
    animationSpeed: 600,
    arcFadeTime: 10000,
    arcSharpness: 1,
    strokeColor: '#333333',
    strokeWidth: 2
