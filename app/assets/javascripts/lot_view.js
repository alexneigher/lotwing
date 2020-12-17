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

  map.on('click', 'new_vehicle_occupied_spaces', open_popup);
  map.on('click', 'used_vehicle_occupied_spaces', open_popup);
  map.on('click', 'loaner_occupied_spaces', open_popup);
  map.on('click', 'lease_return_occupied_spaces', open_popup);
  map.on('click', 'wholesale_unit_occupied_spaces', open_popup);
  map.on('click', 'sold_vehicle_spaces', open_popup);

  window.map.on('load', function () {

    fetch_data_and_render('parking_lots');

    setTimeout(function(){
      fetch_data_and_render('buildings');
    }, 1000);

    setTimeout(function(){
      fetch_data_and_render('landscaping');
    },700);


    setTimeout(function(){
      console.log('timeout')
      // fetch parking spaces
      display_mode = getUrlParameter("display_mode") || '';
      parking_lot = getUrlParameter("parking_lot_name") || '';
      $.ajax({
        url:"/web_api/shapes/parking_spaces?display_mode=" + display_mode + "&parking_lot_name=" + parking_lot + "",
        dataType: "json",
        success: function(data){
          add_shapes_to_map(data, window.map, 'used_vehicle_occupied_spaces');
          add_shapes_to_map(data, window.map, 'new_vehicle_occupied_spaces');
          add_shapes_to_map(data, window.map, 'loaner_occupied_spaces');
          add_shapes_to_map(data, window.map, 'lease_return_occupied_spaces');
          add_shapes_to_map(data, window.map, 'wholesale_unit_occupied_spaces');
          add_shapes_to_map(data, window.map, 'sold_vehicle_spaces');
          add_shapes_to_map(data, window.map, 'empty_parking_spaces');

          // treat duplicate parkings similar to events
          add_shape_overlay_icons(data, window.map, 'duplicate_parked_spaces');

          // treat service holds parkings similar to events
          add_shape_overlay_icons(data, window.map, 'service_hold_spaces');

          // treat sales holds parkings similar to events
          add_shape_overlay_icons(data, window.map, 'sales_hold_spaces');

          fetch_events_and_render();
        },
        error: function (xhr) {
          alert(xhr.statusText)
        }
      }); //end ajax

    },600);//end setTimeout

  });

  $(document).on('click', '.close', function(){
    hide_vehicle_data();
  })

})//$(function)

function fetch_events_and_render(){
  // fetch all events to render icons
  display_mode = getUrlParameter("display_mode") || '';
  parking_lot = getUrlParameter("parking_lot_name") || '';
  $.ajax({
    url:"/web_api/events/?display_mode=" + display_mode + "&parking_lot_name=" + parking_lot + "",
    dataType: "json",
    success: function(data){
      add_events_to_map(data, window.map, "note_events");
      add_events_to_map(data, window.map, "test_drive_events");
      add_events_to_map(data, window.map, "fuel_vehicle_events");
    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}

function open_popup(e){
  $('#vehicle_data_container').html("Loading...");
  display_mode = getUrlParameter("display_mode") || '';
  $.ajax({
    url:"/web_api/shapes/" + e.features[0].properties.shape_id + "?display_mode=" + display_mode,

    success: function(data){
      $('#vehicle_data_container').html(data);

    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}


function hide_vehicle_data(){
  $('#vehicle_data_container').html('');
}