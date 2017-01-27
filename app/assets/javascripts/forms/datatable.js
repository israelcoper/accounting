var forms = forms || {};

forms.datatable = (function() {
  var datatable = function() {
    $("#table-transactions").dataTable({
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
      "sPagingType": "full_numbers",
      "bLengthChange": false,
      "aoColumnDefs": [
        {"bSearchable": false, "aTargets": [0, 4, 5, 6, 7, 8]},
        {"bSortable": false, "aTargets": [2, 4, 5, 6, 7, 8]},
        {"className": "action", "targets": 8}
      ]
    });

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
      "sPagingType": "full_numbers",
      "bLengthChange": false,
      "aoColumnDefs": [
        {"bSearchable": false, "aTargets": [0, 3, 4, 5, 6, 7]},
        {"bSortable": false, "aTargets": [2, 3, 4, 5, 6, 7]},
        {"className": "action", "targets": 7}
      ]
    });
  };

  return {
    init: function() {
      datatable();
    }
  }
}());
