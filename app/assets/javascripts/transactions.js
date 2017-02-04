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
      'placeholder': 'Choose a product'
    },
    {
      'selector': 'select#invoice_number',
      'placeholder': 'Select invoice number'
    },
    {
      'selector': 'select#product_unit',
      'placeholder': 'Select unit'
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
    if ($(this).val() == "new") {
      $(this).val("").trigger("change");
      $(this).parent().removeClass("has-error");
      $(this).parent().find(".help-block").css("display", "none");
      $("#form-transaction input[type='submit']").removeAttr('disabled');
      $("#my_modal").modal();
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

  /*
  $("select#filter").on("change", function(e) {
    var filter = $(this).val();
    var url = window.location.href;
    url = url.split("?")[0] + "?filter=" + filter;
    window.location.href = url;
  });
  */

});

function dateFormat(date,format) {
  var date = new Date(date);
  var day = date.getDate();
  var month = date.getMonth();
  var year = date.getFullYear();

  if (date.getDate() < 10 ) {
    day = "0" + date.getDate();
  }

  if (date.getMonth() < 10) {
    month = date.getMonth() + 1;
    month = "0" + month;
  }

  switch(format) {
    case "yyyy-mm-dd":
      date = [year, month, day].join("-");
      break;
    case "mm/dd/yyyy":
      date = [month, day, year].join("/");
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
        transaction_date:  dateFormat(data.transaction_date, "mm/dd/yyyy"),
        due_date: dateFormat(data.due_date, "mm/dd/yyyy"),
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
