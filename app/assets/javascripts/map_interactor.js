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

  var popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false
  });

  map.on('mouseenter', 'used_vehicle_occupied_space', function(e) {
     
      var coordinates = e.features[0].geometry.coordinates;
      var description = "Shape: " + e.features[0].properties.shape_id;

      // Ensure that if the map is zoomed out such that multiple
      // copies of the feature are visible, the popup appears
      // over the copy being pointed to.
      while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
      }

      popup.setLngLat(coordinates[0][0])
        .setHTML(description)
        .addTo(map);
  });

  map.on('mouseleave', 'used_vehicle_occupied_space', function() {
      popup.remove();
  });

  window.map.on('load', function () {

    $.ajax({
      url:"/api/shapes/vehicles_index",
      dataType: "json",
      success: function(data){
        console.log(data);
        add_shapes_to_map(data, window.map, 'parking_lot');
        add_shapes_to_map(data, window.map, 'parking_area');
        add_shapes_to_map(data, window.map, 'building');
        add_shapes_to_map(data, window.map, 'used_vehicle_occupied_space');
        add_shapes_to_map(data, window.map, 'new_vehicle_occupied_space');
        add_shapes_to_map(data, window.map, 'empty_parking_space');

        center_map(data);

      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });

  window.map.on('click', 'new_vehicle_occupied_space', function(e){
    parking_space_click(e);
  })

  window.map.on('click', 'used_vehicle_occupied_space', function(e){
    parking_space_click(e);
  })

  window.map.on('click', 'empty_parking_space', function(e){
    parking_space_click(e);
  })



})//$(function)


function parking_space_click(e){
  //render info about this particular parking spot
  id = e.features[0].properties.shape_id

  $.ajax({
    url:"/api/shapes/" + id,
    dataType: "json",
    success: function(data){
      render_parking_space_data(data);
    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}

function render_parking_space_data(data){
  if (data.vehicle){
    $('#newTagForm').addClass('d-none');
    $('#newTagForm #tag_shape_id').val(null);
    $('.vehicle-list').removeClass('list-group-item-success');
    $('#vehicle_'+data.vehicle.id).addClass('list-group-item-success');
    
  }else{
    $('.vehicle-list').removeClass('list-group-item-success');
    $('#newTagForm').removeClass('d-none');
    $('#newTagForm #tag_shape_id').val(data.shape.id);
  }
       
}


