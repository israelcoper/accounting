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
            'product[cost]': {
              validators: {
                notEmpty: {
                  message: 'The cost is required'
                },
                numeric: {
                  message: 'Please enter a valid integer',
                  decimalSeparator: '.'
                }
              }
            },
            'product[fields][average_kilo_per_sack]': {
              validators: {
                notEmpty: {
                  message: 'The average kilo per sack is required'
                },
                integer: {
                  message: 'Please enter a valid integer'
                }
              }
            },
            'product[fields][number_of_sack]': {
              validators: {
                notEmpty: {
                  message: 'The number of sack is required'
                },
                integer: {
                  message: 'Please enter a valid integer'
                },
                callback: {
                  message: 'Number of sack does not match with the number of kilo over average kilo per sack',
                  callback: function(value, validator, $field) {
                    var average_kilo_per_sack = $('input#product_fields_average_kilo_per_sack').val();
                    var number_of_kilo = $('input#product_fields_number_of_kilo').val();

                    var number_of_sack = Math.ceil(number_of_kilo / average_kilo_per_sack);

                    return value == number_of_sack;
                  }
                }
              }
            },
            'product[fields][number_of_kilo]': {
              validators: {
                notEmpty: {
                  message: 'The number of kilo is required'
                },
                integer: {
                  message: 'Please enter a valid integer'
                }
              }
            },
            'product[fields][purchasing_price]': {
              validators: {
                notEmpty: {
                  message: 'The purchasing price is required'
                },
                numeric: {
                  message: 'Please enter a valid integer',
                  decimalSeparator: '.'
                }
              }
            },
            'product[fields][selling_price]': {
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
            'product[fields][quantity]': {
              validators: {
                notEmpty: {
                  message: 'The quantity is required'
                },
                integer: {
                  message: 'Please enter a valid integer'
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
