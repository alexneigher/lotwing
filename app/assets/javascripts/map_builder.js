$(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  var map = new mapboxgl.Map({
    container: 'map',
    center: [-122.4194, 37.7749],
    zoom: 10,
    style: 'mapbox://styles/mapbox/satellite-v9'
  });

  var draw = new MapboxDraw({
    displayControlsDefault: false,
    controls: {
      polygon: true,
      trash: true
    }  
  });

  map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken
  }));


  map.addControl(draw, 'top-left');

  map.on('draw.create', function (e) {
    //save to server?
    $('#shape-form').removeClass('d-none');
    $("#shape-form #shape_geo_info").val(JSON.stringify(e.features[0]));
  });

  map.on('load', function () {

    $.ajax({
      url:"/api/shapes",
      dataType: "json",
      success: function(data){
        for(var i=0, size=data.length; i<size; i++){
          console.log(data[i]);
          add_shape_to_map(data[i], map)
        }
        if (data.length > 0) {
          //recenter the map
          var bbox = turf.extent(data[0].geo_info.geometry);
          map.fitBounds(bbox, {
            padding: 50,
            duration: 0
          });
        }
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });

})//$(function)


function add_shape_to_map(shape, map){
  map.addLayer({
      'id': "" + shape.shape_type + shape.id,
      'type': 'fill',
      'source': {
          'type': 'geojson',
          'data': shape.geo_info
      },
      'layout': {},
      'paint': {
          'fill-color': map_shape_type_to_color(shape.shape_type),
          'fill-opacity': 0.5
      }
    });
}

function map_shape_type_to_color(shape_type) {
  var hash  = {
                "parking_space": "red",
                "parking_area": 'green',
                "parking_lot": 'blue',
                "building": 'white',
              }
  return hash[shape_type]
}