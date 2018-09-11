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
        'fill-outline-color': map_shape_type_to_outline(shape_type),
    }
  });
}

function map_shape_type_to_color(shape_type) {
  var hash  = {
                "new_vehicle_occupied_space": "#006699",
                "used_vehicle_occupied_space": "#66CC00",
                'empty_parking_space': '#cccccc',
                'parking_space': '#cccccc',
                "parking_area": 'green',
                "parking_lot": '#ffffff',
                "building": '#FF9933',
              }

  return hash[shape_type]
}

function map_shape_type_to_outline(shape_type){
  if (shape_type == 'parking_lot'){
    return '#FF9933'
  }else{
    return '#fff'
  }
}