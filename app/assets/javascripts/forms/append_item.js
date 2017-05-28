var forms = forms || {};

forms.append_item = (function() {
  var attrs = {
    'selector': 'select#item',
    'listing': 'tbody#transaction-items',
    'template': 'transaction_items/append_item',
  };

  var appendItem = function() {
    $(attrs.selector).on('change', function() {
      var accountId  = $(this).data("accountid");
      var itemId  = $(this).find('option:selected').val();

      $.ajax({
        url: ["/accounts", accountId, "items", itemId].join("/"),
        data: {},
        success: function(data) {
          var listing = $("input.transaction_item_item_id");
          var rate = $("form#form-transaction").hasClass("transaction-invoice") ? data.selling_price : data.purchase_price;
          var context = {
            id: data.id,
            name: data.name,
            description: data.description,
            quantity: data.quantity,
            rate: rate
          };

          listing = $.map(listing, function(v,i) { return $(v).val(); });

          if (itemId == "new") {
            $("#modal-form-item").modal();
          }

          if ( (itemId != '') && (itemId != 'new') && ($.inArray(itemId, listing) === -1) ) {
            $(attrs.listing).append(HandlebarsTemplates[attrs.template](context));
          }
        },
        error: function() {
          console.log("Something went wrong!")
        }
      });
    });
  };

  var removeItem = function() {
    $(document).on('click', attrs.listing + ' a.remove-item', function(e) {
      $(this).parent().parent().remove();

      var amount = 0.0;
      var spanText = "PHP0.00";

      // collect all amount values
      var listing = $("td.amount input[name='transaction[transaction_items_attributes][][amount]']");
      var amountValues = $.map(listing, function(v,i) { if ($.isNumeric($(v).val())) { return parseInt($(v).val()) } });

      if (amountValues.length > 0) {
        amount = amountValues.reduce(function(x,y) { return x + y });
        spanText = "PHP" + amount;
      }

      $("span#transaction_total, span#transaction_balance").text(spanText);
      $("input#transaction_total, input#transaction_balance").val(amount);

      e.preventDefault();
    });
  };

  return {
    init: function() {
      appendItem();
      removeItem();
    }
  }
}());
