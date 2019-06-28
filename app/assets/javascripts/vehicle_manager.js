$(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  window.map = new mapboxgl.Map({
    container: 'map',
    center: [-122.4194, 37.7749],
    zoom: 10,
    bearing: -60, // bearing in degrees
    style: {
      version: 8,
      sources: {},
      layers: [
        {
          id: 'background',
          type: 'background',
          paint: { 
            'background-color': 'white' 
          }
        }
      ]
    }
  });

  window.map.on('load', function () {

    $.ajax({
      url:"/web_api/shapes",
      dataType: "json",
      success: function(data){
        add_shapes_to_map(data, window.map, 'parking_lots');
        add_shapes_to_map(data, window.map, 'buildings');
        add_shapes_to_map(data, window.map, 'parking_spaces');

        center_map(data);
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });
})//$(function)


