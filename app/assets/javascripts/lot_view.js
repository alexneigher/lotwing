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

  window.popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false
  });

  map.on('mouseenter', 'new_vehicle_occupied_spaces', handle_mouseover);
  map.on('mouseenter', 'used_vehicle_occupied_spaces', handle_mouseover);

  map.on('mouseleave', 'new_vehicle_occupied_spaces', function() {
      popup.remove();
  });
  map.on('mouseleave', 'used_vehicle_occupied_spaces', function() {
      popup.remove();
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

})//$(function)

function handle_mouseover(e){
  var coordinates = e.features[0].geometry.coordinates;

  // Ensure that if the map is zoomed out such that multiple
  // copies of the feature are visible, the popup appears
  // over the copy being pointed to.
  while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
      coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
  }

  popup.setLngLat(coordinates[0][0])
    .setHTML("Loading...")
    .addTo(map);

  $.ajax({
    url:"/api/shapes/" + e.features[0].properties.shape_id,
    dataType: "json",
    success: function(data){
      str = tooltip_html(data)
      popup.setHTML(str)
    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}

function tooltip_html(data){
  str = "<div>VIN: <strong>"+data.vehicle.vin+"</strong></div>" +
        "<div>"+data.vehicle.year+" "+data.vehicle.make+"</div>" +
        "<div>"+data.vehicle.model+" "+data.vehicle.color+"</div>" +
        "<div>"+data.tag.note+"</div>" +
        "<div>"+days_ago(data.tag.created_at)+" days in stock</div>"
  return str
}

function days_ago(created_at_date){
  var date2 = new Date();
  var date1 = new Date(created_at_date);
  
  return Math.round((date2-date1)/(1000*60*60*24));
}