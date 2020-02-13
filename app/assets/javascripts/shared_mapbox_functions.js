function fetch_data_and_render(shape_type){
  $.ajax({
    url:"/web_api/shapes/"+shape_type,
    dataType: "json",
    success: function(data){
      add_shapes_to_map(data, window.map, shape_type);

      if (shape_type == 'parking_lots'){
        center_map(data);
      }
    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });
}

function center_map(data){
  if (data['parking_lots'].length > 0) {
    //recenter the map
    var bbox = turf.extent(data['parking_lots'][0].geo_info.geometry);
    window.map.fitBounds(bbox, {
      padding: 0,
      duration: 0
    });
    set_bearing();
    set_zoom();
  }
}

function set_bearing(){
  bearing = $('#dealership_map_bearing').val();
  if (bearing){
    window.map.setBearing(bearing)
  }
}

function set_zoom(){
  zoom = $('#dealership_map_zoom').val();
  if (zoom){
    window.map.setZoom(zoom)
  }
}

function add_shapes_to_map(data, map, shape_type){
  features = data[shape_type]
  if (!features){
    return false;
  };

  geo_info = []

  for(var i=0, size=features.length; i<size; i++){
    features[i].geo_info.properties.shape_id = features[i].id

    features[i].geo_info.properties.fill_opacity = shape_opacity(features[i].most_recently_tagged_at, shape_type);

    geo_info.push(features[i].geo_info)
  }

  map.addLayer({
    'id': shape_type,
    'type': 'fill',
    'source': {
        'type': 'geojson',
        "data": {
                  "type": "FeatureCollection",
                  "features": geo_info
                }
    },
    'layout': {},
    'paint': {
        'fill-color': map_shape_type_to_color(shape_type),
        'fill-opacity': ['get', 'fill_opacity']
    }
  });

  smooth_borders(shape_type);

}


function smooth_borders(source_name){
  window.map.addLayer({
    id: "lots-smooth-borders" + source_name,
    type: "line",
    source: source_name,
    layout: {},
    paint: {
      "line-color": "#6b6d6f", // same whatever color
      "line-width": 0.5
    }
  });
}

function map_shape_type_to_color(shape_type) {
  var hash  = {
                "new_vehicle_occupied_spaces": "#006699",
                "used_vehicle_occupied_spaces": "#66CC00",
                'empty_parking_spaces': '#FFFFFF',
                "duplicate_parked_spaces": "#ff0000",
                "loaner_occupied_spaces": "#E8F051",
                "lease_return_occupied_spaces": "#D13CEA",
                "wholesale_unit_occupied_spaces": "#8D8C88",
                "sold_vehicle_spaces": "#000",
                'parking_spaces': '#FFFFFF',
                "parking_lots": '#CCCCCC',
                "buildings": '#FF9933',
                "landscaping": "#45ba45"
              }

  return hash[shape_type]
}


function map_shape_type_to_opacity(shape_type){
  if (shape_type == 'parking_lots'){
    return 0.4
  }else{
    return 1
  }
}

function add_shape_overlay_icons(data, map, event_type){
  var geo_json_array = []

  for(var i = 0; i < data[event_type].length; i++){
    geo_json_array.push( { data: {attributes: {parking_space: data[event_type][i].geo_info}} } )
  }
  data = {};
  data[event_type] = geo_json_array;
  add_events_to_map(data, map, event_type);
}

function add_events_to_map(data, map, event_type){
  var geo_json_array = []

  for(var i = 0; i < data[event_type].length; i++){

    if (event_type == "duplicate_parked_spaces" || event_type == "service_hold_spaces" || event_type == "sales_hold_spaces"){
      tag_json = data[event_type][i];
    }else{
      tag_json = JSON.parse(data[event_type][i]);
    }

    geo_json = tag_json.data.attributes.parking_space;
    geo_json_array.push(geo_json);
  }

  map.loadImage(map_image_url_to_event_type(event_type), function(error, image) {
      if (error) throw error;
      map.addImage(event_type+"_image", image);
      map.addLayer({
          "id": event_type,
          "type": "symbol",
          "source": {
              "type": "geojson",
              "data": {
                  "type": "FeatureCollection",
                  "features": geo_json_array
              }
          },
          "layout": {
              "icon-image": event_type+"_image",
              "icon-size": map_event_type_to_size(event_type)
          }
      });
  });

}

function map_image_url_to_event_type(event_type){
  var hash  = {
                "note_events": "https://upload.wikimedia.org/wikipedia/commons/d/de/MB_line_1_icon.png",
                "test_drive_events": "https://vignette.wikia.nocookie.net/leapfrog/images/b/be/Yellow_Circle.png",
                "fuel_vehicle_events": "https://vignette.wikia.nocookie.net/leapfrog/images/b/be/Yellow_Circle.png",
                "duplicate_parked_spaces": "plus-24.png",
                "service_hold_spaces": "triangle-24.png",
                "sales_hold_spaces": "sales_hold_h.png"
              }

  return hash[event_type]
}

function map_event_type_to_size(event_type){
  var hash  = {
                "note_events": 0.007,
                "test_drive_events": 0.01,
                "fuel_vehicle_events": 0.01,
                "duplicate_parked_spaces": 0.4,
                "service_hold_spaces": 0.45,
                "sales_hold_spaces": 0.35
              }

  return hash[event_type]
}

function shape_opacity(most_recently_tagged_at, shape_type){
  vehicle_shapes = ["used_vehicle_occupied_spaces", "new_vehicle_occupied_spaces", "loaner_occupied_spaces", "lease_return_occupied_spaces", "wholesale_unit_occupied_spaces"]

  if (shape_type == 'parking_lots'){
    return 0.4
  }else if(vehicle_shapes.includes(shape_type)){

    // for parking spaces that are more than 12 hours old, make them transparent
    hours_old = Math.abs(new Date() - new Date(most_recently_tagged_at)) / 36e5

    if (hours_old > 24){
      return 0.4
    }else{
      return 1
    }

  }else{
    return 1
  }

}


var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};