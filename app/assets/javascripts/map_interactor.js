$(function(){
  window.map.setStyle({
    version: 8,
    sources: {
    },
    layers: [
      {
        id: 'background',
        type: 'background',
        paint: { 
          'background-color': 'white' 
        }
      }
    ]
  })
  window.map.on('click', 'full_parking_space', function(e){
    parking_space_click(e);
  })
  window.map.on('click', 'empty_parking_space', function(e){
    parking_space_click(e);
  })

})

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
    $('.vehicle-list').removeClass('focused');
    $('#vehicle_'+data.vehicle.id).addClass('focused');
    
  }else{
    $('.vehicle-list').removeClass('focused');
    $('#newTagForm').removeClass('d-none');
    $('#newTagForm #tag_shape_id').val(data.shape.id);
  }
       
}