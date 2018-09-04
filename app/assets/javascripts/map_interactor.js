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
  str = "<div>Parking Space Id: " + data.id + "</div>" +
        "<hr>" +
        "<div>Currently Empty</div" 

  $el.html(str);
}