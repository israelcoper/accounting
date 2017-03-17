var forms = forms || {};

forms.validate_product = (function() {
  return {
    init: function() {
      var $form = $('#form-product');

      if ( $form.length ) {
        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'product[name]': {
              validators: {
                notEmpty: {
                  message: 'The product name is required'
                }
              }
            },
            'product[purchase_price]': {
              validators: {
                notEmpty: {
                  message: 'The purchase price is required'
                },
                numeric: {
                  message: 'Please enter a valid integer',
                  decimalSeparator: '.'
                }
              }
            },
            'product[selling_price]': {
              validators: {
                notEmpty: {
                  message: 'The selling price is required'
                },
                numeric: {
                  message: 'Please enter a valid integer',
                  decimalSeparator: '.'
                }
              }
            },
            'product[quantity]': {
              validators: {
                notEmpty: {
                  message: 'The quantity is required'
                },
                integer: {
                  message: 'Please enter a valid integer'
                }
              }
            },
            'product[unit]': {
              validators: {
                notEmpty: {
                  message: 'The unit is required'
                }
              }
            },
            'product[product_number]': {
              validators: {
                notEmpty: {
                  message: 'The product number is required'
                }
              }
            }
          }
        }).on('success.form.bv', function(e) {
        }).on('err.form.bv', function(e) {
        });
      }
    }
  }
}());
