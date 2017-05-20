var forms = forms || {};

forms.append_quantity = (function() {
  var appendQuantity = function() {
    $(document).on("keyup keypress", "input[name='transaction[transaction_items_attributes][][quantity]']", function(e) {
      var parent = $(this).parent().parent().parent();
      var quantity = $(this).val();
      // var remainingQuantity = parent.find("td.quantity-in-hand span").text();
      var rate = parent.find("td.rate span").text(); 
      var total = parseInt(quantity) * parseInt(rate);
      var amount = 0.0;
      var spanText = "PHP0.00";

      parent.find("td.amount span").text("");
      parent.find("td.amount input[name='transaction[transaction_items_attributes][][amount]']").val("");

      $("span#transaction-total, span#transaction-balance").text(spanText);
      $("input#transaction-total, input#transaction-balance").val(amount);

      // TODO: quantity validation to accept integers only -- note: disable submit button if user input is NaN and display error message

      if (e.which == 13) {
        // validate if value is positive integer
        if (/^\d+$/.test(total)) {
          parent.find("td.amount span").text(total);
          parent.find("td.amount input[name='transaction[transaction_items_attributes][][amount]']").val(total);

          // collect all amount values
          var listing = $("td.amount input[name='transaction[transaction_items_attributes][][amount]']");
          var amountValues = $.map(listing, function(v,i) { if ($.isNumeric($(v).val())) { return parseInt($(v).val()) } });

          if (amountValues.length > 0) {
            amount = amountValues.reduce(function(x,y) { return x + y });
            spanText = "PHP" + amount;
          }

          $("span#transaction-total, span#transaction-balance").text(spanText);
          $("input#transaction-total, input#transaction-balance").val(amount);

          // validate if quantity does not exceed remaining quantity of invoice transaction only
          /*
           *
          if ($('form#form-transaction').hasClass('transaction-invoice')) {
            if (parseInt(quantity) > parseInt(remainingQuantity)) {
              $(this).parent().addClass("has-error");
              if ($(this).parent().find("small").length == 0) {
                $(this).parent().append("<small class='help-block'>Quantity exceeds the remaining count of this item</small>");
              }
              $("input[type='submit']").attr("disabled", "disabled");
            } else {
              $(this).parent().removeClass("has-error");
              $(this).parent().find("small").remove();

              if ( !$("tbody#items .form-group").hasClass("has-error") && (parseInt($("input#transaction-balance").val()) > 0) ) {
                $("input[type='submit']").removeAttr("disabled");
              }
            }
          }
          *
          */
        }

        e.preventDefault();
        return false;
      }
    });
  };

  return {
    init: function() {
      appendQuantity();
    }
  }
}());
