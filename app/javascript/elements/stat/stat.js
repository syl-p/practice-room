import Chart from 'chart.js/auto';
import lineConfig from './line.config';
import doughnutConfig from './doughnut.config';

export class Stat extends HTMLElement {
  constructor() {
    super();
    this.shadow = this.attachShadow({ mode: 'open' });
    this.shadow.innerHTML = `
      <style>
        :host {
          display: block;
          width: 100%;
          overflow: hidden;
        }
        .chart {
          width: 100%;
        }
      </style>
      <canvas class="chart"></canvas>
    `;
    this.canvas = this.shadow.querySelector('canvas');
    this.ctx = this.canvas.getContext('2d');
    this.chart = null;
  }

  connectedCallback() {
    this.labels = JSON.parse(this.getAttribute('labels'));
    this.values = JSON.parse(this.getAttribute('values'));
    this.type = this.getAttribute('type');
    switch (this.type) {
      case "doughnut":
        this.config = doughnutConfig;
        break;
      default:
        this.config = lineConfig;
        break;
    }
    this.render();
  }

  render() {
    const labels = this.labels
    const values = this.values

    // gradient color for area
    const gradient = this.ctx.createLinearGradient(0, 0, 0, 140);
    gradient.addColorStop(0, 'rgb(72, 149, 247)');
    gradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
    if (this.type === 'line') {
      this.config.dataset.backgroundColor = gradient;
    }

    this.chart = new Chart(this.canvas, {
      type: this.type,
      data: {
        labels,
        datasets: [
          {
            label: 'temps de pratique',
            data: values,
            ...this.config.dataset,
          }
        ]
      },
      ...this.config.general
    });
  }
}
