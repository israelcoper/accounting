$(document).on('turbolinks:load', function(e) {
  // validations
  var $form = $('#form-income-statement');
  if ( $form.length ) {
    $form.bootstrapValidator({
      framework: 'bootstrap',
      fields: {
        'date[year]': {
          validators: {
            notEmpty: {
              message: 'Please select year'
            }
          }
        }
      }
    }).on('success.form.bv', function(e) {
    }).on('err.form.bv', function(e) {
    });
  }
});
