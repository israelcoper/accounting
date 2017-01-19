var forms = forms || {};

forms.validate_transaction = (function() {
  return {
    init: function() {
      var $form = $('#form-transaction');

      if ( $form.length ) {
        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'transaction[person_id]': {
              validators: {
                notEmpty: {
                  message: 'Select a value'
                }
              }
            },
            'transaction[transaction_date]': {
              validators: {
                notEmpty: {
                  message: 'Select transaction date'
                }
              }
            },
            'transaction[due_date]': {
              validators: {
                callback: {
                  message: 'The value must be greater than the invoice date',
                  callback: function(value, validator, $field) {
                    transaction_date = new Date($('#transaction_transaction_date').val());
                    due_date = new Date($('#transaction_due_date').val());

                    return (due_date > transaction_date) ? true : false 
                  }
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
