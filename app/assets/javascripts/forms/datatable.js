var forms = forms || {};

forms.datatable = (function() {
  var datatable = function() {
    // Sales and Purchases transactions table
    var table = $("#table-transactions").dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": function(data,callback,settings) {
        $.ajax({
          "url": $("#table-transactions").data('source'),
          "type": "GET",
          "data": data,
          "success": function(response) {
            callback(response);
          }
        });
      },
      "deferRender": true,
      "sPagingType": "full_numbers",
      "bLengthChange": false,
      "aoColumnDefs": [
        {"bSearchable": false, "aTargets": [0, 4, 5, 6, 8]},
        {"bSortable": false, "aTargets": [2, 4, 5, 6, 7, 8]},
        {"className": "action", "targets": 8}
      ],
      initComplete: function() {
        /*
        var $select = $('<select class="form-control input-sm"><option value="">All</option></select>');
        var options = ["Open", "Closed", "Partial", "Paid"];

        $.each(options, function(i,v) { $select.append('<option value="'+ v +'">'+ v +'</option>') });
        $select.insertBefore("#table-transactions_filter label");
        $select.on('change', function() {
          var val = $.fn.dataTable.util.escapeRegex( $(this).val() );
          table.api().column(7).search( val ).draw();
        });
        */
      }
    });

    // Customer and Supplier transactions table
    $("#table-person-transactions").dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": function(data,callback,settings) {
        $.ajax({
          "url": $("#table-person-transactions").data('source'),
          "type": "GET",
          "data": data,
          "success": function(response) {
            callback(response);
          }
        });
      },
      "deferRender": true,
      "sPagingType": "full_numbers",
      "bLengthChange": false,
      "aoColumnDefs": [
        {"bSearchable": false, "aTargets": [0, 3, 4, 5, 6, 7]},
        {"bSortable": false, "aTargets": [2, 3, 4, 5, 6, 7]},
        {"className": "action", "targets": 7}
      ]
    });

    // Expenses transactions table
    $("#table-expenses").dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": function(data,callback,settings) {
        $.ajax({
          "url": $("#table-expenses").data('source'),
          "type": "GET",
          "data": data,
          "success": function(response) {
            callback(response);
          }
        });
      },
      "deferRender": true,
      "sPagingType": "full_numbers",
      "bLengthChange": false,
      "aoColumnDefs": [
        {"bSearchable": false, "aTargets": [0, 4, 6]},
        {"bSortable": false, "aTargets": [2, 3, 4, 5, 6]},
        {"className": "action", "targets": 6}
      ]
    });

    // Employee transactions table
    $("#table-employee-transactions").dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": function(data,callback,settings) {
        $.ajax({
          "url": $("#table-employee-transactions").data('source'),
          "type": "GET",
          "data": data,
          "success": function(response) {
            callback(response);
          }
        });
      },
      "deferRender": true,
      "sPagingType": "full_numbers",
      "bLengthChange": false,
      "aoColumnDefs": [
        {"bSearchable": false, "aTargets": [0, 3, 5]},
        {"bSortable": false, "aTargets": [2, 3, 4, 5]},
        {"className": "action", "targets": 5}
      ]
    });
  };

  return {
    init: function() {
      datatable();
    }
  }
}());
