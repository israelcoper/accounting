var forms = forms || {};

forms.validate_item = (function() {
  return {
    init: function() {
      var $form = $('#form-item');

      if ( $form.length ) {
        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'item[name]': {
              validators: {
                notEmpty: {
                  message: 'The item name is required'
                }
              }
            },
            'item[purchase_price]': {
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
            'item[selling_price]': {
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
            'item[quantity]': {
              validators: {
                notEmpty: {
                  message: 'The quantity is required'
                },
                integer: {
                  message: 'Please enter a valid integer'
                }
              }
            },
            'item[unit]': {
              validators: {
                notEmpty: {
                  message: 'The unit is required'
                }
              }
            },
            'item[item_number]': {
              validators: {
                notEmpty: {
                  message: 'The item number is required'
                }
              }
            },
            'item[allocated_to_purchase]': {
              validators: {
                notEmpty: {
                  message: 'The field is required'
                }
              }
            },
            'item[allocated_to_selling]': {
              validators: {
                notEmpty: {
                  message: 'The field is required'
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
