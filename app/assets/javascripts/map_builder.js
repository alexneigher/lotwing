$(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  window.map = new mapboxgl.Map({
    container: 'map',
    center: [-122.4194, 37.7749],
    zoom: 10,
    style: 'mapbox://styles/mapbox/satellite-v9'
  });

  window.modes = MapboxDraw.modes;
  modes.draw_rectangle = DrawRectangle.default;
  modes.rotate = RotateMode;

  window.draw = new MapboxDraw({
      modes: window.modes,
      displayControlsDefault: false,
      controls: {
        trash: true
      }
  });
  window.map.addControl(window.draw, 'top-left');

  window.draw.changeMode('simple_select');

  window.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken
  })
  window.map.addControl(geocoder);

  RotateMode.rotateend = function(selectedFeature) {
    console.log('ROTATEEND');

    console.log('feature: ', selectedFeature);
  }

  window.map.on('draw.create', function (e) {
    $('#shape-form').removeClass('d-none');
    shapes = window.draw.getAll().features;
    $("#shape-form #shape_geo_info").val( JSON.stringify(shapes) );
  });
  window.map.on('draw.update', function (e) {
    $('#shape-form').removeClass('d-none');
    shapes = window.draw.getAll().features;
    $("#shape-form #shape_geo_info").val( JSON.stringify(shapes) );
  });

  window.map.on('load', function () {

    $.ajax({
      url:"/web_api/shapes",
      dataType: "json",
      success: function(data){
        add_shapes_to_map(data, window.map, 'parking_lots');
        add_shapes_to_map(data, window.map, 'buildings');
        add_shapes_to_map(data, window.map, 'parking_spaces');

        center_map(data);
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });

  window.map.on('click', 'parking_spaces', function(e){
    //find the element on the left side, highlight it
    animate_scroll_to(e);
  })

   window.map.on('click', 'buildings', function(e){
    //find the element on the left side, highlight it
    animate_scroll_to(e);
  })

  //bind listener to map rotate inout
  $("#dealership_map_bearing").on('keyup',function(){
    window.map.setBearing(this.value);
  })

  // //bind listener to map zoom inout
  $("#dealership_map_zoom").on('keyup',function(){
    window.map.setZoom(this.value);
  })


})//$(function)


function animate_scroll_to(e){
  id = e.features[0].properties.shape_id
  $('#'+id).addClass('list-group-item-success').siblings().removeClass('list-group-item-success');

  $('#shapeList').animate(
      {
        scrollTop: $('#'+id).position().top - $('#shapeList').position().top + $('#shapeList').scrollTop(),
      },
      'fast');
}