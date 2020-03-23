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

    features[i].geo_info.properties.fill_opacity = shape_opacity(features[i].most_recently_tagged_at, features[i].temporary, shape_type);

    features[i].geo_info.properties.fill_color = shape_color(features[i].most_recently_tagged_at, shape_type);

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
        'fill-color': ['get', 'fill_color'],
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
      "line-color": "#6b6d6f",
      "line-width": 0.5
    }
  });
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

function shape_opacity(most_recently_tagged_at, temporary, shape_type){

  if ((shape_type == "empty_parking_spaces" || shape_type == "parking_spaces") && temporary == true){
    //the or here is for only empty spaces, or if in map builder, all spaces
    return 0.00
  }else{

    return 1
  }


}

function shape_color(most_recently_tagged_at, shape_type){
  var stale = 0
  var hours_old = Math.abs(new Date() - new Date(most_recently_tagged_at)) / 36e5

  if (hours_old > 24){
    stale = 1
  }

  var hash = {
                "new_vehicle_occupied_spaces": {0: "#376794", 1: "#9CB6C6"},
                "used_vehicle_occupied_spaces": {0: "#90C055", 1: "#C5DB9D"},
                'empty_parking_spaces': {0: "#fff", 1: "#fff"},
                "duplicate_parked_spaces": {0: "#ff000", 1: "#ff000"},
                "loaner_occupied_spaces": {0: "#E6E570", 1: "#EBECB4"},
                "lease_return_occupied_spaces": {0: "#9A5C9D", 1: "#C893BC"},
                "wholesale_unit_occupied_spaces": {0: "#8D8C88", 1: "#C4C2C2"},
                "sold_vehicle_spaces": {0: "#000", 1: "#000"},
                'parking_spaces': {0: "#fff", 1: "#fff"},
                "parking_lots": {0: "#EBEBEB", 1: "#EBEBEB"},
                "buildings": {0: "#F29836", 1: "#F29836"},
                "landscaping": {0: "#067C3E", 1: "#067C3E"}
              }

  return hash[shape_type][stale]
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