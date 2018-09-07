$(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  window.map = new mapboxgl.Map({
    container: 'map',
    center: [-122.4194, 37.7749],
    zoom: 10,
    style: 'mapbox://styles/mapbox/satellite-v9'
  });

  window.draw = new MapboxDraw();
  window.map.addControl(window.draw, 'top-left');

  // investigate line slice
  // https://github.com/BrunoSalerno/mapbox-gl-draw-cut-line-mode

  window.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken
  })
  window.map.addControl(geocoder);


  window.map.on('draw.create', function (e) {
    $('#exportSave').removeClass('d-none');
  });

  window.map.on('load', function () {

    $.ajax({
      url:"/api/shapes",
      dataType: "json",
      success: function(data){
        add_shapes_to_map(data, window.map, 'parking_lot');
        add_shapes_to_map(data, window.map, 'parking_area');
        add_shapes_to_map(data, window.map, 'building');
        add_shapes_to_map(data, window.map, 'empty_parking_space');
        add_shapes_to_map(data, window.map, 'full_parking_space');


        if (data['parking_lot'].length > 0) {
          //recenter the map
          var bbox = turf.extent(data['parking_lot'][0].geo_info.geometry);
          window.map.fitBounds(bbox, {
            padding: 5,
            duration: 0
          });
        }
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });

  window.map.on('click', 'empty_parking_space', function(e){
    //find the element on the left side, highlight it

    id = e.features[0].properties.shape_id
    $('#'+id).addClass('list-group-item-success').siblings().removeClass('list-group-item-success');
  })

  window.map.on('click', 'full_parking_space', function(e){
    //find the element on the left side, highlight it

    id = e.features[0].properties.shape_id
    $('#'+id).addClass('list-group-item-success').siblings().removeClass('list-group-item-success');
  })


  // when ready to save, toggle the actual form visitibility
  $('#exportSave').click(function(){
    $(this).addClass('d-none');

    shapes = window.draw.getAll().features;
    $("#shape-form #shape_geo_info").val( JSON.stringify(shapes) );
    $('#shape-form').removeClass('d-none');
  })


})//$(function)