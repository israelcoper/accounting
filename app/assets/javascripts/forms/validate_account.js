var forms = forms || {};

forms.validate_account = (function() {
  return {
    init: function() {
      var $form = $('#form-account');

      if ( $form.length ) {
        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'account[name]': {
              validators: {
                notEmpty: {
                  message: 'The business name is required'
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
