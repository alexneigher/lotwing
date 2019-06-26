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
  
  window.map.on('load', function () {
    fetch_data_and_render('parking_lots');
    fetch_data_and_render('buildings');
    
    // fetch parking spaces
    $.ajax({
      url:"/web_api/shapes/parking_spaces",
      dataType: "json",
      success: function(data){
        console.log(data);
        add_shapes_to_map(data, window.map, 'used_vehicle_occupied_spaces');
        add_shapes_to_map(data, window.map, 'new_vehicle_occupied_spaces');
        add_shapes_to_map(data, window.map, 'loaner_occupied_spaces');
        add_shapes_to_map(data, window.map, 'lease_return_occupied_spaces');
        add_shapes_to_map(data, window.map, 'wholesale_unit_occupied_spaces');
        add_shapes_to_map(data, window.map, 'empty_parking_spaces');
        add_shapes_to_map(data, window.map, 'duplicate_parked_spaces');

        fetch_events_and_render();
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });

  });

  $(document).on('click', '.close', function(){
    hide_vehicle_data();
  })

})//$(function)

function fetch_events_and_render(){
  // fetch all events to render icons
  $.ajax({
    url:"/web_api/events",
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
  show_vehicle_data("Loading...");

  $.ajax({
    url:"/web_api/shapes/" + e.features[0].properties.shape_id,
    dataType: "json",
    success: function(data){
      str = tooltip_html(data)
      show_vehicle_data("<div style='padding: 10px;'><div class='close'>&times;</div>" + str + "</div>");
    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}


function show_vehicle_data(str){
  $('#vehicle_data_container').html(str);
}

function hide_vehicle_data(){
  $('#vehicle_data_container').html('');
}

function tooltip_html(data){
  str = ''

  for (i = 0; i < data.vehicles.length; i++) { 

    str += render_vehicle_year_make(data.vehicles[i]) + 
            render_vehicle_stock_number(data.vehicles[i]) +
            render_vehicle_color(data.vehicles[i]) +
            "<div style='float:left;margin-top:6px;'>"+ data.vehicles[i].age_in_days +" days in stock</div><div style='clear:both;'></div>" +
            render_event(data.events[i])
  }
  
  return str
}

function days_ago(created_at_date){
  var date2 = new Date();
  var date1 = new Date(created_at_date);
  
  return Math.round((date2-date1)/(1000*60*60*24));
}

// Generate the hTML for the tooltip
function render_vehicle_stock_number(vehicle){
  if (vehicle.stock_number){
   return "<div style='padding-right:10px;float:left;margin-top:6px;'>Stock #: <strong>"+vehicle.stock_number+"</strong></div>"
  }else{
    return ""
  }
}

function render_vehicle_year_make(vehicle){
  if (vehicle.year && vehicle.make){
    return "<h3 style='float:left;margin-right: 10px;'><a href='/vehicles/" + vehicle.id + "'>"+vehicle.year+" "+ vehicle.make+" "+ vehicle.model+"</a></h3>"
  }else{
    return ""
  }
  
}

function render_event(events){
  str = ""
  if (events){
    for(var i = 0; i < events.length; i++){
      str += "<hr style='margin:2px;'><div>"+events[i].data.attributes.summary+"</div>"
    }
  }
  return str
}

function render_vehicle_color(vehicle){
  if (vehicle.model && vehicle.color){
    return "<div style='padding-right:10px;float:left;margin-top:6px;'>"+vehicle.color+"</div>"
  }else{
    return ""
  }
  
}