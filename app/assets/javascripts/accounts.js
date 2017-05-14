$(document).on('turbolinks:load', function(e) {
  $("#form-account-chart input").on("keyup keypress", function(e) {
    if (e.which == 13) {
      e.preventDefault();
    }
  });

  forms.validate_account.init();
});
