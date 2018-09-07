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
        'fill-opacity': map_shape_type_to_opacity(shape_type)
    }
  });
}

function map_shape_type_to_color(shape_type) {
  var hash  = {
                "full_parking_space": "white",
                "empty_parking_space": "white",
                "parking_area": 'green',
                "parking_lot": 'blue',
                "building": 'green',
              }

  return hash[shape_type]
}

function map_shape_type_to_opacity(shape_type){
  if (shape_type == 'full_parking_space'){
    return 1
  }else{
    return 0.3
  }
}