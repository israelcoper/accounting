var forms = forms || {};

forms.pop_over = (function() {
  var popOver = function() {
    // transaction children
    $(document).on("click", 'a.transaction-link', function(e) {
      var accountId = $(this).data("account-id");
      var transactionId = $(this).data("transaction-id");

      $.ajax({
        url: ["/accounts", accountId, "transactions", transactionId, "children.json"].join("/"),
        data: {},
        success: function(data) {
          var context = {};
          $("tbody#child-transactions").html("");

          $.each(data, function(index,object) {
            context = {
              account_id: accountId,
              transaction_id: object.id,
              transaction_date: dateFormat(object.transaction_date),
              payment_method: humanize(object.payment_method),
              total: Math.abs(object.total),
              balance: Math.abs(object.balance),
              status: object.status
            };

            $("tbody#child-transactions").append(HandlebarsTemplates['transaction_items/append_children'](context));
          });
        },
        error: function() {
          console.log("Something went wrong!")
        }
      });

      $(this).popover({
        content: $('#child-transactions').html(),
        html: true
      }).on("show.bs.popover", function () {
        $(this).data("bs.popover").tip().css("max-width", "100%");
      }).on("hide.bs.popover", function () {
      });
      $(this).popover('show');
      e.preventDefault();
    });

    // transaction summary
    $(document).on('click', 'a.overdue-link', function(e) {
      var accountId  = $(this).data('account-id');
      var type        = $(this).data('type');
      var startDate  = dateFormat($(this).data('start-date'), 'yyyy-mm-dd');
      var endDate    = dateFormat($(this).data('end-date'), 'yyyy-mm-dd');

      $.ajax({
        url: ["/accounts", accountId, "transactions", "overdue.json"].join("/"),
        data: { type: type, start_date: startDate, end_date: endDate },
        success: function(data) {
          var context = {};
          $("tbody#overdue-transactions").html("");

          $.each(data, function(index,object) {
            var label = (object.status == "Open") ? "default" : "info";
            var route;
            var link;

            if (object.transaction_type == "Invoice") {
              route = "payment";
              link  = "Receive payment";
            } else {
              route = "payment_purchase";
              link  = "Pay order";
            }

            context = {
              account_id: object.account_id,
              person_id: object.person_id,
              transaction_id: object.id,
              transaction_number: object.transaction_number,
              due_date: dateFormat(object.due_date),
              total: Math.abs(object.total),
              balance: Math.abs(object.balance),
              status: object.status,
              label: label,
              route: route,
              link: link
            };

            $("tbody#overdue-transactions").append(HandlebarsTemplates['transaction_items/append_overdue_transaction'](context));
          });
        },
        error: function() {
          console.log("Something went wrong!")
        }
      });

      $(this).popover({
        content: $('#overdue-transactions').html(),
        container: 'body',
        html: true
      }).on("show.bs.popover", function () {
        $(this).data("bs.popover").tip().css("max-width", "900px");
      }).on("hide.bs.popover", function () {
      });
      $(this).popover('show');
      e.preventDefault();
    });
  };

  return {
    init: function() {
      popOver();
    }
  }
}());
