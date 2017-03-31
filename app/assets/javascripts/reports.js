$(document).on('turbolinks:load', function(e) {

  $("select#date_year").on("change", function(e) {
    var value = $(this).val();
    $("input#date_year").val(value);
  });

});
