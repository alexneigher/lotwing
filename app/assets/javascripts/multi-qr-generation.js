$(function(){

  $('.js-activate-multi-qr-mode').click(function(){
    $('.qr-code-toggle').removeClass('d-none');
    $('.js-submit-multi-qr-mode').removeClass('d-none');
    $(this).remove();
  });


  $('.js-submit-multi-qr-mode').click(function(){
    $(".multi-qr-code-toggle:checked").each(function () {

        var stock_number = $(this).data("stock-number");
        var vin = $(this).data("vin");
        window.open("/barcodes.pdf?stock_number="+ stock_number+"&vin="+ vin + "")
    });

    location.reload();
  })

})