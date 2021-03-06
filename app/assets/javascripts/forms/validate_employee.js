var forms = forms || {};

forms.validate_employee = (function() {
  return {
    init: function() {
      var $form = $('#form-employee');

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
            }
          }
        }).on('success.form.bv', function(e) {
        }).on('err.form.bv', function(e) {
        });
      }
    }
  }
}());
