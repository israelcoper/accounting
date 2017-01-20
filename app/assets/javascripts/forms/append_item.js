var forms = forms || {};

forms.append_item = (function() {
  var attrs = {
    'selector': 'select#product',
    'listing': 'tbody#items',
    'template_rice': 'items/append_item_rice',
    'template_grocery': 'items/append_item_grocery'
  };

  var appendItem = function() {
    $(attrs.selector).on('change', function() {
      var account_id  = $(this).data("accountid");
      var product_id  = $(this).find('option:selected').val();
      var product_type = $(this).data('product-type');
      var template;

      switch (product_type) {
        case "rice":
          template = attrs.template_rice;
          break;
        case "grocery_item":
          template = attrs.template_grocery;
          break;
        default:
      }

      $.ajax({
        url: ["/accounts", account_id, "products", product_id].join("/"),
        data: {},
        success: function(data) {
          var listing = $("input.transaction_item_product_id");
          var context;
          var default_fields = {
            id: data.id,
            name: data.name,
            description: data.description
          };
          var dynamic_fields;
          var price;

          if ($("form#form-transaction").hasClass("transaction-invoice")) {
            price = data.fields.selling_price;
          } else {
            price = data.fields.purchasing_price;
          }

          switch (product_type) {
            case "rice":
              dynamic_fields = {
                number_of_sack: data.fields.number_of_sack,
                number_of_kilo: data.fields.number_of_kilo,
                price_per_kilo: price
              };
              break;
            case "grocery_item":
              dynamic_fields = {
                quantity: data.fields.quantity,
                price: price
              };
              break;
            default:
          }

          context = $.extend(default_fields, dynamic_fields);
          listing = $.map(listing, function(v,i) { return $(v).val(); });

          if ( (product_id != '') && ($.inArray(product_id, listing) === -1) ) {
            $(attrs.listing).append(HandlebarsTemplates[template](context));
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
