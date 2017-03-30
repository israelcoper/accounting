var forms = forms || {};

forms.date_select = (function() {
  var dateSelect = function() {
    // modal
    $("select#customer_id, select#supplier_id, select#employee_id").on("select2:select", function(e) {
      var account_id = $("#form-transaction").data("account-id");
      var person_id = $(this).val();
      var resource;

      switch($("#form-transaction").data("transaction-type")) {
        case "purchase":
          resource = "suppliers";
          break;
        case "expense":
          resource = "employees";
          break;
        default:
          resource = "customers";
      }

      if (person_id == "new") {
        $(this).val("").trigger("change");
        $(this).parent().removeClass("has-error");
        $(this).parent().find(".help-block").css("display", "none");
        $("#form-transaction input[type='submit']").removeAttr('disabled');
        $("#my_modal").modal();
      } else {
        $.ajax({
          url: ["/accounts", account_id, resource, person_id, "info.json"].join("/"),
          data: {},
          success: function(data) {
            var now = new Date(Date.now());
            var due = new Date(now.getTime() + (data.credit_terms*24*60*60*1000));

            now = dateFormat(now, "yyyy-mm-dd");
            due = dateFormat(due, "yyyy-mm-dd");

            $("#transaction_transaction_date").val(now);
            $("#transaction_due_date").val(due);
          },
          error: function() {
            console.log("Something went wrong!")
          }
        });
      }
    });

    // datepicker
    $("input#transaction_transaction_date").datepicker({
      format: "yyyy-mm-dd",
      todayHighlight: true,
    }).on('changeDate', function(e) {
      var selector = $(this);
      $("#form-transaction").bootstrapValidator('revalidateField', selector.attr('name'));
      $("#transaction_due_date").val($(this).val());
    });

    $("input#transaction_due_date").datepicker({
      format: "yyyy-mm-dd",
      todayHighlight: true,
    }).on('changeDate', function(e) {
      var selector = $(this);
      $("#form-transaction").bootstrapValidator('revalidateField', selector.attr('name'));
    });

    if ($("form#form-transaction").hasClass("form-payment")) {
      var now = new Date(Date.now());
      now = dateFormat(now, "yyyy-mm-dd");

      $("#transaction_transaction_date").val(now);
    }
  };

  return {
    init: function() {
      dateSelect();
    }
  }
}());
