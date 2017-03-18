var forms = forms || {};

forms.validate_supplier = (function() {
  return {
    init: function() {
      var $form = $('#form-supplier');

      if ( $form.length ) {
        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'person[first_name]': {
              validators: {
                notEmpty: {
                  message: 'The first name is required'
                }
              }
            },
            'person[last_name]': {
              validators: {
                notEmpty: {
                  message: 'The last name is required'
                }
              }
            },
            'person[credit_limit]': {
              validators: {
                notEmpty: {
                  message: 'The credit limit is required'
                },
                numeric: {
                  message: 'Please enter a valid integer',
                  decimalSeparator: '.'
                }
              }
            },
             'person[credit_terms]': {
              validators: {
                notEmpty: {
                  message: 'The credit terms is required'
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
