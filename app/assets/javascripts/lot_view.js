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


  window.map.on('load', function () {
    fetch_data_and_render('parking_lots');
    fetch_data_and_render('buildings');
    
    // fetch parking spaces
    $.ajax({
      url:"/web_api/shapes/parking_spaces",
      dataType: "json",
      success: function(data){
        add_shapes_to_map(data, window.map, 'used_vehicle_occupied_spaces');
        add_shapes_to_map(data, window.map, 'new_vehicle_occupied_spaces');
        add_shapes_to_map(data, window.map, 'empty_parking_spaces');

        fetch_events_and_render();
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });

  });

})//$(function)

function fetch_events_and_render(){
  // fetch all events to render icons
  $.ajax({
    url:"/web_api/events",
    dataType: "json",
    success: function(data){
      add_events_to_map(data, window.map, "note_events");
      add_events_to_map(data, window.map, "test_drive_events");
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
      show_vehicle_data("<div style='padding: 10px;'>" + str + "</div>");
    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}


function show_vehicle_data(str){
  $('#vehicle_data_container').html(str);
}

function hide_vehicle_data(str){
  $('#vehicle_data_container').html('');
}

function tooltip_html(data){
  console.log(data)
  str = render_vehicle_year_make(data) + 
        render_vehicle_stock_number(data) +
        render_vehicle_model_color(data) +
        "<div>"+days_ago(data.vehicle.created_at)+" days in stock</div>" +
        render_event(data)

  return str
}

function days_ago(created_at_date){
  var date2 = new Date();
  var date1 = new Date(created_at_date);
  
  return Math.round((date2-date1)/(1000*60*60*24));
}

// Generate the hTML for the tooltip
function render_vehicle_stock_number(data){
  if (data.vehicle.stock_number){
   return "<div>Stock #: <strong>"+data.vehicle.stock_number+"</strong></div>"
  }else{
    return ""
  }
}

function render_vehicle_year_make(data){
  if (data.vehicle.year && data.vehicle.make){
    return "<h3><a target='_blank' href='/vehicles/" + data.vehicle.id + "'>"+data.vehicle.year+" "+data.vehicle.make+"</a></h3>"
  }else{
    return ""
  }
  
}

function render_event(data){
  str = ""
  if (data.events){
    for(var i = 0; i < data.events.length; i++){
      str += "<hr><div>"+data.events[i].data.attributes.summary+"</div>"
    }
  }

  return str
}

function render_vehicle_model_color(data){
  if (data.vehicle.model && data.vehicle.color){
    return "<div>"+data.vehicle.model+" "+data.vehicle.color+"</div>"
  }else{
    return ""
  }
  
}