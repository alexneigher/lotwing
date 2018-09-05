$(function(){
  window.map.on('click', 'parking_space', function(e){
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
  })

})


function render_parking_space_data(data){
  $el = $('#parkingSpaceInfoContainer');

  console.log(data);
  str = "<div>Parking Space Id: " + data.shape.id + "</div>" +
        "<hr>";
  if (data.vehicle){
    $('#newTagForm').addClass('d-none');
    $('#newTagForm #tag_shape_id').val();

    str += "Occupied: <div>" + data.vehicle.make + " - " + data.vehicle.model + "</div>" +
           "<a href='/tags/"+data.tag.id+"/deactivate'>clear this parking space</a>"

  }else{
    $('#newTagForm').removeClass('d-none');
    $('#newTagForm #tag_shape_id').val(data.shape.id);
  }
       
  $el.html(str);
}