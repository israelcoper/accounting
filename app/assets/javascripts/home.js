$(document).on('turbolinks:load', function(e) {

  if ($("#profit-and-loss").length > 0) {
    var purchases = $("#profit-and-loss").data("purchases");
    var sales = $("#profit-and-loss").data("sales");

    Highcharts.chart('profit-and-loss', {
      chart: {
        type: 'column'
      },
      title: {
        text: 'Quarterly Sales and Purchases'
      },
      xAxis: {
        categories: [
          'Q1',
          'Q2',
          'Q3',
          'Q4'
        ],
        crosshair: true
      },
      yAxis: {
        min: 0,
        title: {
          text: 'Amount (php)'
        }
      },
      tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>PHP{point.y:.1f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      },
      plotOptions: {
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      },
      series: [{
        name: 'Income',
        data: sales
      }, {
        name: 'Cost',
        data: purchases
      }]
    });
  }

});
