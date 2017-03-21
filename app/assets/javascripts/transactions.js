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
  var dropdown_selectors = [
    {
      'selector': 'select#customer_id',
      'placeholder': 'Choose a customer'
    },
    {
      'selector': 'select#supplier_id',
      'placeholder': 'Choose a supplier'
    },
    {
      'selector': 'select#product',
      'placeholder': 'Choose a product/service'
    },
    {
      'selector': 'select#invoice_number',
      'placeholder': 'Select invoice number'
    },
    {
      'selector': 'select#product_unit',
      'placeholder': 'Select unit'
    },
    {
      'selector': 'select#product_category',
      'placeholder': 'Select category'
    },
    {
      'selector': 'select#transaction_payment_method',
      'placeholder': 'Select payment method'
    }
  ];

  dropdown_selectors.forEach(function(dropdown) {
    $(dropdown.selector).select2({
      theme: "bootstrap",
      placeholder: dropdown.placeholder,
      allowClear: true
    });
  });

  // modal
  $("select#customer_id, select#supplier_id").on("select2:select", function(e) {
    var account_id = $("#form-transaction").data("account-id");
    var person_id = $(this).val();
    var resource = "customers";

    if ($("#form-transaction").data("transaction-type") == "purchase") {
      resource = "suppliers";
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

  $(document).on("click", '[data-toggle=popover]', function(e) {
    var account_id = $(this).data("account-id");
    var transaction_id = $(this).data("transaction-id");

    $.ajax({
      url: ["/accounts", account_id, "transactions", transaction_id, "children.json"].join("/"),
      data: {},
      success: function(data) {
        $("tbody#child-transactions").html("");
        $.each(data, function(index,object) {
          var context = {
            account_id: account_id,
            transaction_id: object.id,
            transaction_date: dateFormat(object.transaction_date),
            payment_method: humanize(object.payment_method),
            total: Math.abs(object.total),
            balance: Math.abs(object.balance),
            status: object.status
          };

          $("tbody#child-transactions").append(HandlebarsTemplates['items/append_children'](context));
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
