import helper from '../../helper';

export default {
  dataset : {
    borderColor: '#4895f7',
    tension: 0.5
  },
  general: {
    locale: 'fr',
    options: {
      fill: true,
      plugins: {
        legend: {
          display: false,
        },
        tooltip: {
          callbacks: {
            title: function(context) {
              return "Temps de pratique";
            },
            label: function(context) {
              return helper.formatDate(new Date(context.label)) + ': ' + helper.convertHMS(context.raw);
            }
          }
        }
      },
      scales: {
        xAxis: {
          display: false,
        },
        yAxis: {
          display: false,
        }
      }
    }
  }
}
