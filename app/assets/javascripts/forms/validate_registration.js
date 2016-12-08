var forms = forms || {};

forms.validate_registration = (function() {
  return {
    init: function() {
      var $form = $('#form-registration, #form-user');
      var regex = new RegExp("(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^a-zA-Z])");

      if ( $form.length ) {
        $form.bootstrapValidator({
          framework: 'bootstrap',
          icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'user[first_name]': {
              validators: {
                notEmpty: {
                  message: 'The first name is required'
                }
              }
            },
            'user[last_name]': {
              validators: {
                notEmpty: {
                  message: 'The last name is required'
                }
              }
            },
            'user[username]': {
              validators: {
                notEmpty: {
                  message: 'The username is required'
                }
              }
            },
            'user[password]': {
              validators: {
                notEmpty: {
                  message: 'The password is required'
                },
                stringLength: {
                  min: 8,
                  message: 'Your password is too short (minimum is 8 characters)'
                },
                regexp: {
                  regexp: regex,
                  message: 'The password must contain 3 of 4 following chars: uppercase, lowercase, number, special characters'
                }
              }
            },
            'user[password_confirmation]': {
              validators: {
                notEmpty: {
                  message: 'The password confirmation is required'
                },
                identical: {
                  field: 'user[password]',
                  message: 'Password confirmation do not match'
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
