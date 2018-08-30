$(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  var map = new mapboxgl.Map({
    container: 'map',
    center: [-68.13734351262877, 45.137451890638886],
    zoom: 13,
    style: 'mapbox://styles/mapbox/streets-v10'
  });
  var draw = new MapboxDraw();

  // Map#addControl takes an optional second argument to set the position of the control.
  // If no position is specified the control defaults to `top-right`. See the docs 
  // for more details: https://www.mapbox.com/mapbox-gl-js/api/map#addcontrol

  map.addControl(draw, 'top-left');

  map.on('load', function() {
    // ALL YOUR APPLICATION CODE
    draw.add({ type: 'Point', coordinates: [0, 0] });
    draw.add({ type: 'Point', coordinates: [1, 1] });
    draw.add({ type: 'Point', coordinates: [2, 2] });
    console.log(draw.getAll());
  });
    
})//$(function)
