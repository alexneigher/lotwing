function fetch_data_and_render(shape_type){
  $.ajax({
    url:"/api/shapes/"+shape_type,
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
        'fill-outline-color': "#CCCCCC",
        'fill-opacity': map_shape_type_to_opacity(shape_type)
    }
  });
}

function map_shape_type_to_color(shape_type) {
  var hash  = {
                "new_vehicle_occupied_spaces": "#006699",
                "used_vehicle_occupied_spaces": "#66CC00",
                'empty_parking_spaces': '#FFFFFF',
                'parking_spaces': '#cccccc',
                "parking_areas": 'green',
                "parking_lots": '#CCCCCC',
                "buildings": '#FF9933',
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
