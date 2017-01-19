var forms = forms || {};

forms.append_invoice = (function() {
  var appendInvoice = function() {
    if ($('form.form-payment').length > 0) {
      var account_id = $("select#invoice_number").data("accountid");
      var parent_id  = $("#transaction_parent_id").val();
      var person_id  = $("select[name='transaction[person_id]'] option:selected").val();

      // append options to select invoice number
      if (person_id.length > 0) {
        appendOptionToSelectInvoiceNumber(account_id, person_id);
      }

      $("select[name='transaction[person_id]']").on("change", function(e) {
        person_id = $(this).find("option:selected").val();
        $("select#invoice_number option").remove();
        $("tbody#transaction tr").remove();
        $("input#transaction_parent_id").val("");
        if (person_id.length > 0)
          appendOptionToSelectInvoiceNumber(account_id, person_id);
      });

      // append invoice to payment transaction
      if (parent_id.length > 0) {
        appendTransaction(account_id, parent_id);
      }

      $("select#invoice_number").on("change", function(e) {
        parent_id = $(this).find("option:selected").val(); 
        $("tbody#transaction tr").remove();
        if (parent_id.length > 0) {
          appendTransaction(account_id, parent_id);
          $("input#transaction_parent_id").val(parent_id);
        } else {
          $("input#transaction_parent_id").val("")
        }
      });

      $(document).on("keyup keypress", "input[name='transaction[payment]']", function(e) {
        var span_text = "PHP0.0";
        var open_balance = $(".transaction_balance span").text();
        var payment = $(this).val();

        open_balance = parseInt(open_balance);
        payment = parseInt(payment);

        $("span#transaction_payment").text(span_text);

        if (e.which == 13) {
          // validate if value is positive integer
          if ( /^\d+$/.test(payment) ) {
            span_text = "PHP" + payment;
            $("span#transaction_payment").text(span_text);

            // validate if amount does not exceed open balance
            if (payment > open_balance) {
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
