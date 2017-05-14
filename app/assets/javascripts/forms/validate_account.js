var forms = forms || {};

forms.validate_account = (function() {
  return {
    init: function() {
      var $form = $('#form-account');

      if ( $form.length ) {
        $("#wizard-wrapper #form-account").steps({
          headerTag: "h3",
          bodyTag: "section",
          transitionEffect: "slideLeft",
          stepsOrientation: "vertical",
          enablePagination: false,
          enableAllSteps: true
        });

        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          excluded: ':disabled',
          fields: {
            'account[name]': {
              validators: {
                notEmpty: {
                  message: 'The business name is required'
                }
              }
            },
            'account[industry]': {
              validators: {
                notEmpty: {
                  message: 'The business type is required'
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
