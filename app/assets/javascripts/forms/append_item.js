var forms = forms || {};

forms.append_item = (function() {
  var attrs = {
    'selector': 'select#product',
    'listing': 'tbody#items',
    'template': 'items/append_item',
  };

  var appendItem = function() {
    $(attrs.selector).on('change', function() {
      var account_id  = $(this).data("accountid");
      var product_id  = $(this).find('option:selected').val();

      $.ajax({
        url: ["/accounts", account_id, "products", product_id].join("/"),
        data: {},
        success: function(data) {
          var listing = $("input.transaction_item_product_id");
          var price = $("form#form-transaction").hasClass("transaction-invoice") ? data.selling_price : data.purchasing_price;
          var context = {
            id: data.id,
            name: data.name,
            description: data.description,
            quantity: data.quantity,
            price: price
          };

          listing = $.map(listing, function(v,i) { return $(v).val(); });

          if (product_id == "new") {
            $("#modal_form_product").modal();
          }

          if ( (product_id != '') && (product_id != 'new') && ($.inArray(product_id, listing) === -1) ) {
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
      var span_text = "PHP0.00";

      // collect all amount values
      var listing = $("td.amount input[name='transaction[items_attributes][][amount]']");
      var amount_values = $.map(listing, function(v,i) { if ($.isNumeric($(v).val())) { return parseInt($(v).val()) } });

      if (amount_values.length > 0) {
        amount = amount_values.reduce(function(x,y) { return x + y });
        span_text = "PHP" + amount;
      }

      $("span#transaction_total, span#transaction_balance").text(span_text);
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
