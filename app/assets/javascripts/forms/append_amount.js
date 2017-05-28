var forms = forms || {};

forms.append_amount = (function() {
  var appendAmount = function() {
    $(document).on("keyup keypress", "input[name='transaction[transaction_items_attributes][][amount]']", function(e) {
      var amount = $(this).val();
      var spanText = "PHP0.00";

      $("span#transaction_total").text(spanText);
      $("input#transaction_total, input#transaction_balance").val(0);

      // TODO: quantity validation to accept integers only -- note: disable submit button if user input is NaN and display error message

      if (e.which == 13) {
        // validate if value is positive integer
        if (/^\d+$/.test(amount)) {
          // collect all amount values
          var listing = $("td.amount input[name='transaction[transaction_items_attributes][][amount]']");
          var amountValues = $.map(listing, function(v,i) { if ($.isNumeric($(v).val())) { return parseInt($(v).val()) } });

          if (amountValues.length > 0) {
            amount = amountValues.reduce(function(x,y) { return x + y });
            spanText = "PHP" + amount;
          }

          $("span#transaction_total").text(spanText);
          $("input#transaction_total, input#transaction_balance").val(amount);

          if ($("input#transaction_total").val() > 0) {
            $("input[type=submit]").removeAttr("disabled");
          }
        }

        e.preventDefault();
        return false;
      }
    });
  };

  return {
    init: function() {
      appendAmount();
    }
  }
}());
