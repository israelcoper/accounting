$(document).on('turbolinks:load', function(e) {
  $("select#account_industry").select2({
    theme: "bootstrap",
    placeholder: "Type of Business",
    allowClear: true
  });

  $("#form-account-chart input").on("keyup keypress", function(e) {
    if (e.which == 13) {
      e.preventDefault();
    }
  });
 
  forms.validate_account.init();
});
