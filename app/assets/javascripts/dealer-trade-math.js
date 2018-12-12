$(function(){
  $('.delivered-invoice-inputs input.dynamic').keyup(function(){
      var invoice_value_str = $('#dealer_trade_delivered_invoice').val();
      var invoice_value = Number(invoice_value_str.replace(/[^0-9.-]+/g,""));

      var invoice_accessories_str = $('#dealer_trade_plus_deliver_acc').val();
      var invoice_accessories = Number(invoice_accessories_str.replace(/[^0-9.-]+/g,""));

      var invoice_dealer_rebate_str = $('#dealer_trade_less_rebate_1').val();
      var invoice_dealer_rebate = Number(invoice_dealer_rebate_str.replace(/[^0-9.-]+/g,""));



      result = invoice_value + invoice_accessories - invoice_dealer_rebate

      var num = '$' + result.toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
      $("#dealer_trade_delivered_total").val(num);

      calculate_trade_difference();
  })


  $('.received-invoice-inputs input.dynamic').keyup(function(){
      var value_str = $('#dealer_trade_received_invoice').val();

      var value = Number(value_str.replace(/[^0-9.-]+/g,""));

      var accessories_str = $('#dealer_trade_received_acc').val();
      var accessories = Number(accessories_str.replace(/[^0-9.-]+/g,""));

      var dealer_rebate_str = $('#dealer_trade_received_rebate').val();
      var dealer_rebate = Number(dealer_rebate_str.replace(/[^0-9.-]+/g,""));



      result = value + accessories - dealer_rebate

      var num = '$' + result.toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
      $("#dealer_trade_received_sum").val(num);

      calculate_trade_difference();
  })
})

function calculate_trade_difference(){
  var delivered_str = $("#dealer_trade_delivered_total").val()
  var delivered = Number(delivered_str.replace(/[^0-9.-]+/g,""));

  var received_str = $("#dealer_trade_received_sum").val();
  var received = Number(received_str.replace(/[^0-9.-]+/g,""));

  
  result = delivered - received
  var num = '$' + result.toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
  
  $("#dealer_trade_trade_difference").val(num);
}