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
        console.log(data);
        add_shapes_to_map(data, window.map, 'parking_lots');
        add_shapes_to_map(data, window.map, 'parking_areas');
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

  //bind listener to map rotate inout
  $("#dealership_map_bearing").on('keyup',function(){
    window.map.setBearing(this.value);
  })

  // //bind listener to map zoom inout
  $("#dealership_map_zoom").on('keyup',function(){
    window.map.setZoom(this.value);
  })


})//$(function)