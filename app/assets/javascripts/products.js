$(document).on('turbolinks:load', function(e) {
  forms.validate_product.init();

  $("select#product_category").on("change", function(e) {
    var value = $(this).val();

    if (value == "inventory") {
      $(".inventory").css("display", "block");
    } else {
      $(".inventory").css("display", "none");
    }
  });
});
