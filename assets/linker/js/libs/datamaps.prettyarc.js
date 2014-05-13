if (typeof DatamapsPlugins === 'undefined') {
  var DatamapsPlugins = {};
}

// Similar to datamap's arc plugin, with some added features:
//  1. arcs fade away after a given number of milliseconds (options.arcFadeTime)
//  2. "impact" animations when arcs trajectories finish animating
DatamapsPlugins.handlePrettyArc = function(layer, data, options) {


  var self = this,
  svg = this.svg;

  if ( !data || (data && !data.slice) ) {
    throw "Datamaps Error - arcs must be an array";
  }

  if ( typeof options === "undefined" ) {
    options = defaultOptions.arcConfig;
  }

  var arcs = layer.selectAll('path.datamaps-prettyarc').data( data, JSON.stringify );

  arcs
  .enter()
  .append('svg:path')
  .attr('class', 'datamaps-prettyarc')
  .style('stroke-linecap', 'round')
  .style('stroke', function(datum) {
    if ( datum.options && datum.options.strokeColor) {
      return datum.options.strokeColor;
    }
    return  options.strokeColor
  })
  .style('fill', 'none')
  .style('stroke-width', function(datum) {
    if ( datum.options && datum.options.strokeWidth) {
      return datum.options.strokeWidth;
    }
    return options.strokeWidth;
  })
  .attr('d', function(datum) {
    var originXY = self.latLngToXY(datum.origin.latitude, datum.origin.longitude);
    var destXY = self.latLngToXY(datum.destination.latitude, datum.destination.longitude);
    var midXY = [ (originXY[0] + destXY[0]) / 2, (originXY[1] + destXY[1]) / 2];

    return "M" + originXY[0] + ',' + originXY[1] + "S" + (midXY[0] + (50 * options.arcSharpness)) + "," + (midXY[1] - (75 * options.arcSharpness)) + "," + destXY[0] + "," + destXY[1];
  })
  .transition()
  .delay(100)
  .style('fill', function() {
    /*
       Thank you Jake Archibald, this is awesome.
Source: http://jakearchibald.com/2013/animated-line-drawing-svg/
*/
      var length = this.getTotalLength();
      this.style.transition = this.style.WebkitTransition = 'none';
      this.style.strokeDasharray = length + ' ' + length;
      this.style.strokeDashoffset = length;
      this.getBoundingClientRect();
      //this.style.transition = this.style.WebkitTransition = 'stroke-dashoffset ' + options.animationSpeed + 'ms ease-out';

      var strokeEffect = this.style.WebkitTransition = 'stroke-dashoffset ' + options.animationSpeed + 'ms ease-out';

      var fadeTime = options.arcFadeTime / 1000;
      var fadeOut = ', visibility 0s ' + fadeTime + 's,';
      fadeOut += ' opacity ' + fadeTime + 's linear';
      this.style.transition =  strokeEffect + fadeOut;

      this.style.opacity = 0;

      this.style.strokeDashoffset = '0';


      return 'none';

  })
  .delay(200)
    .each("end", function(datum) { // START CUSTOM STUFF 
        var destXY = self.latLngToXY(datum.destination.latitude, datum.destination.longitude);
        var circle = svg.append('circle');
        circle.attr("cy", destXY[1])
        .attr("cx", destXY[0])
        .attr("r", 0);

        circle.transition()
        .attr("r", 20)
        .duration(1000)
        .style("opacity", 0)
        .duration(1000)
        .each("end", function() {
          // remove the circle element
          d3.select(this).remove();
          });
        });

        // TODO: comment explaining this
  arcs.exit()
    .transition()
    .style('opacity', 0)
    .remove();

}
