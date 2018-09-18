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

    fetch_data_and_render('parking_lots');
    fetch_data_and_render('buildings');
    
    $.ajax({
      url:"/api/shapes/parking_spaces",
      dataType: "json",
      success: function(data){
        add_shapes_to_map(data, window.map, 'used_vehicle_occupied_spaces');
        add_shapes_to_map(data, window.map, 'new_vehicle_occupied_spaces');
        add_shapes_to_map(data, window.map, 'empty_parking_spaces');

      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });

  window.map.on('click', 'new_vehicle_occupied_spaces', function(e){
    parking_space_click(e);
  })

  window.map.on('click', 'used_vehicle_occupied_spaces', function(e){
    parking_space_click(e);
  })

  window.map.on('click', 'empty_parking_spaces', function(e){
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

