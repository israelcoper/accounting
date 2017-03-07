$(document).on('turbolinks:load', function(e) {
  $("select#account_industry").select2({
    theme: "bootstrap",
    placeholder: "Type of Business",
    allowClear: true
  });
 
  forms.validate_account.init();
});
