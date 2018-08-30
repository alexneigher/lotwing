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

  map.addControl(draw, 'top-left');

  map.on('draw.click')    

  map.on('draw.create', function (e) {
    //save to server?
    console.log(JSON.stringify(e.features[0]))
    $("#shape_geo_info").val(JSON.stringify(e.features[0]));
  });

  map.on('load', function () {

    var counties = $.ajax({
      url:"/api/shapes",
      dataType: "json",
      success: function(data){
        for(let i=0, size=data.length; i<size; i++){
          add_shape_to_map(data[i], map)
          add_shape_to_list(data[i]);
        }

        //recenter the map
        console.log(data[0]);
        var coordinates = data[0].geo_info.geometry.coordinates//.features[0].geometry.coordinates;
        console.log(coordinates[0]);

        // Pass the first coordinates in the LineString to `lngLatBounds` &
        // wrap each coordinate pair in `extend` to include them in the bounds
        // result. A variation of this technique could be applied to zooming
        // to the bounds of multiple Points or Polygon geomteries - it just
        // requires wrapping all the coordinates with the extend method.
        map.fitBounds(coordinates[0], {
          padding: 100,
          duration: 0
        });
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    })

  
  });

})//$(function)


function add_shape_to_list(shape){
  $('#shape-list').append("<li>"+shape.id+"</li>");
}

function add_shape_to_map(shape, map){
  map.addLayer({
      'id': "space_"+shape.id,
      'type': 'fill',
      'source': {
          'type': 'geojson',
          'data': shape.geo_info
      },
      'layout': {},
      'paint': {
          'fill-color': '#088',
          'fill-opacity': 0.8
      }
    });
}