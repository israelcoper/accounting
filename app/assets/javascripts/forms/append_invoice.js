var forms = forms || {};

forms.append_invoice = (function() {
  var appendInvoice = function() {
    if ($('form.form-payment').length > 0) {
      var accountId = $("select#invoice_number").data("accountid");
      var parentId  = $("#transaction_parent_id").val();
      var personId  = $("select[name='transaction[person_id]'] option:selected").val();

      // append options to select invoice number
      if (personId.length > 0) {
        appendOptionToSelectInvoiceNumber(accountId, personId);
      }

      $("select[name='transaction[person_id]']").on("change", function(e) {
        person_id = $(this).find("option:selected").val();
        $("select#invoice_number option").remove();
        $("tbody#transaction tr").remove();
        $("input#transaction_parent_id").val("");
        if (personId.length > 0)
          appendOptionToSelectInvoiceNumber(accountId, personId);
      });

      // append invoice to payment transaction
      if (parentId.length > 0) {
        appendTransaction(accountId, parentId);
      }

      $("select#invoice_number").on("change", function(e) {
        parentId = $(this).find("option:selected").val(); 
        $("tbody#transaction tr").remove();
        if (parentId.length > 0) {
          appendTransaction(accountId, parentId);
          $("input#transaction_parent_id").val(parentId);
        } else {
          $("input#transaction_parent_id").val("")
        }
      });

      $(document).on("keyup keypress", "input[name='transaction[payment]']", function(e) {
        var spanText = "PHP0.0";
        var openBalance = $(".transaction_balance span").text();
        var payment = $(this).val();

        openBalance = parseInt(openBalance);
        payment = parseInt(payment);

        $("span#transaction_payment").text(spanText);

        if (e.which == 13) {
          // validate if value is positive integer
          if ( /^\d+$/.test(payment) ) {
            spanText = "PHP" + payment;
            $("span#transaction_payment").text(spanText);

            // validate if amount does not exceed open balance
            if (payment > openBalance) {
              $(this).parent().addClass("has-error");
              if ($(this).parent().find("small").length == 0) {
                $(this).parent().append("<small class='help-block'>Payment exceeds the open balance</small>");
              }
              $("input[type='submit']").attr("disabled", "disabled");
            } else {
              $(this).parent().removeClass("has-error");
              $(this).parent().find("small").remove();

              if ( !$("tbody#transaction .form-group").hasClass("has-error") ) {
                $("input[type='submit']").removeAttr("disabled");
              }
            }
          }

          e.preventDefault();
          return false;
        }
      });
    }
  };

  return {
    init: function() {
      appendInvoice();
    }
  }
}());
