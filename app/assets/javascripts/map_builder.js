$(function(){
  
  L.mapbox.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  window.map = L.mapbox.map('map', 'mapbox.satellite')
      .setView([37.7749, -122.4194], 10);


  var featureGroup = L.featureGroup().addTo(window.map);
  var drawControl = new L.Control.Draw({
    edit: {
      featureGroup: featureGroup
    }
  }).addTo(window.map);

  window.map.on('draw:created', function(e) {
    console.log(e.layer);
    featureGroup.addLayer(e.layer);
  });

  $('#export').click(function(){
    var data = featureGroup.toGeoJSON();

    console.log(data);
    
  })


  $.ajax({
    url:"/api/shapes",
    dataType: "json",
    success: function(data){
      //first merge the geojson with database id info
      for(var i = 0; i< data.empty_parking_space.length; i++){
        data.empty_parking_space[i].geo_info.properties.shape_id = data.empty_parking_space[i].id
      }

      var shapes = L.geoJson(data.empty_parking_space[0].geo_info, {
        // Executes on each feature in the dataset
        onEachFeature: function (featureData, featureLayer) {
          
          // featureData contains the actual feature object
          // featureLayer contains the indivual layer instance
          featureLayer.on('click', function () {
            // Fires on click of single feature
            console.log(featureData)
          });
        }
      })

      shapes.addTo(window.map);


      // add_shapes_to_map(data, window.map, 'parking_lot');
      // add_shapes_to_map(data, window.map, 'parking_area');
      // add_shapes_to_map(data, window.map, 'building');
      // 
      // add_shapes_to_map(data, window.map, 'full_parking_space');

    },
    error: function (xhr) {
      alert(xhr.statusText)
    }
  });

  function whenClicked(e) {
    // e = event
    console.log(e);
    // You can make your ajax call declaration here
    //$.ajax(... 
  }

  function onEachFeature(feature, layer) {
    //bind click
    layer.on({
        click: whenClicked
    });
  }




//   window.map.on('draw.create', function (e) {
//     //save to server?
//     $('#shape-form').removeClass('d-none');
//     $("#shape-form #shape_geo_info").val(JSON.stringify(e.features[0]));
//   });

//   window.map.on('load', function () {

    


//   window.map.on('click', 'empty_parking_space', function(e){
//     //find the element on the left side, highlight it

//     id = e.features[0].properties.shape_id
//     $('#'+id).addClass('list-group-item-success').siblings().removeClass('list-group-item-success');
//   })

//   window.map.on('click', 'full_parking_space', function(e){
//     //find the element on the left side, highlight it

//     id = e.features[0].properties.shape_id
//     $('#'+id).addClass('list-group-item-success').siblings().removeClass('list-group-item-success');
//   })


})//$(function)





// function map_shape_type_to_color(shape_type) {
//   var hash  = {
//                 "full_parking_space": "yellow",
//                 "empty_parking_space": "red",
//                 "parking_area": 'green',
//                 "parking_lot": 'blue',
//                 "building": 'white',
//               }
//   return hash[shape_type]
// }