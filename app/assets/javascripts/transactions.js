$(document).on('turbolinks:load', function(e) {
  // datatable
  forms.datatable.init();

  // append item
  forms.append_item.init();

  // append quantity (invoice)
  forms.append_quantity.init();

  // append invoice
  forms.append_invoice.init();

  // form validation
  forms.validate_transaction.init();

  // select2
  forms.select_box.init();

  // modal and datepicker
  forms.date_select.init();

  // popover
  forms.pop_over.init();
});

function humanize(string) {
  return string.replace(/_/g, ' ').replace(/(\w+)/g, function(match) { return match.charAt(0).toUpperCase() + match.slice(1); });
}

function dateFormat(date,format) {
  var date = new Date(date);
  var day = date.getDate();
  var month = date.getMonth() + 1;
  var year = date.getFullYear();
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  if (day < 10 ) {
    day = "0" + day;
  }

  if (month < 10) {
    month = "0" + month;
  }

  switch(format) {
    case "yyyy-mm-dd":
      date = [year, month, day].join("-");
      break;
    case undefined:
      month = months[parseInt(month) - 1];
      date = [day, month, year].join(" ");
      break;
    default:
  }
  return date;
}

function appendOptionToSelectInvoiceNumber(account_id, person_id) {
  var resource = "customers";

  if ($("form.form-payment").data("payment") == "purchase") {
    resource = "suppliers";
  }

  $.ajax({
    url: ["/accounts", account_id, resource, person_id, "transactions.json"].join("/"),
    data: {},
    success: function(data) {
      $("select#invoice_number").append("<option></option>");
      $.each(data, function(index, object) {
        $("select#invoice_number").append("<option value='"+object.id+"'>"+object.transaction_number+"</option>");
      });
    },
    error: function() {
      console.log("Something went wrong!")
    }
  });
}

function appendTransaction(account_id, parent_id) {
  $.ajax({
    url: ["/accounts", account_id, "transactions", parent_id+".json"].join("/"),
    data: {},
    success: function(data) {
      context = {
        current_date: dateFormat(new Date(), "yyyy-mm-dd"),
        transaction_number: data.transaction_number,
        transaction_date:  dateFormat(data.transaction_date),
        due_date: dateFormat(data.due_date),
        total: data.total,
        balance: data.balance
      };
      $("tbody#transaction").append(HandlebarsTemplates['items/append_transaction'](context))
    },
    error: function() {
      console.log("Something went wrong!")
    }
  }); 
}
