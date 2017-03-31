var forms = forms || {};

forms.select_box = (function() {
  var selectBox = function() {
    var dropdown_selectors = [
      {
        'selector': 'select#customer_id',
        'placeholder': 'Choose a customer'
      },
      {
        'selector': 'select#supplier_id',
        'placeholder': 'Choose a supplier'
      },
      {
        'selector': 'select#employee_id',
        'placeholder': 'Choose an employee'
      },
      {
        'selector': 'select#product',
        'placeholder': 'Choose a product/service'
      },
      {
        'selector': 'select#invoice_number',
        'placeholder': 'Select invoice number'
      },
      {
        'selector': 'select#product_unit',
        'placeholder': 'Select unit'
      },
      {
        'selector': 'select#product_category',
        'placeholder': 'Select category'
      },
      {
        'selector': 'select#transaction_payment_method',
        'placeholder': 'Select payment method'
      },
      {
        'selector': 'select#date_year',
        'placeholder': 'Select year'
      }
    ];

    dropdown_selectors.forEach(function(dropdown) {
      $(dropdown.selector).select2({
        theme: "bootstrap",
        placeholder: dropdown.placeholder,
        allowClear: true
      });
    });
  };

  return {
    init: function() {
      selectBox();
    }
  }
}());
