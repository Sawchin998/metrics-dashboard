// src/app/components/line-chart.component.ts
import { Component, Input, OnInit, OnChanges } from '@angular/core';
import { Chart, ChartConfiguration } from 'chart.js';
import { Metric } from '../models/metric.model';

@Component({
  selector: 'app-line-chart',
  template: '<canvas id="lineChart"></canvas>'
})
export class LineChartComponent implements OnInit, OnChanges {
  @Input() metrics: Metric[] = [];
  
  private chart: Chart | undefined;
  
  ngOnInit() {
    this.createChart();
  }
  
  ngOnChanges() {
    // WHY: Update chart when new data arrives
    if (this.chart) {
      this.updateChart();
    }
  }
  
  private createChart() {
    // WHY: Chart.js configuration for line chart
    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: [],
        datasets: this.createDatasets()
      },
      options: {
        responsive: true,
        scales: {
          x: {
            type: 'time',
            time: {
              unit: 'minute'
            }
          },
          y: {
            beginAtZero: true,
            max: 100
          }
        }
      }
    };
    
    this.chart = new Chart('lineChart', config);
  }
  
  private createDatasets() {
    // WHY: Separate data by category for multi-line chart
    const categories = [...new Set(this.metrics.map(m => m.category))];
    
    return categories.map(category => {
      const categoryMetrics = this.metrics.filter(m => m.category === category);
      
      return {
        label: category,
        data: categoryMetrics.map(m => ({
          x: new Date(m.timestamp),
          y: m.value
        })),
        borderColor: this.getColorForCategory(category),
        backgroundColor: this.getColorForCategory(category, 0.1),
        tension: 0.1
      };
    });
  }
  
  private updateChart() {
    if (!this.chart) return;
    
    this.chart.data.datasets = this.createDatasets();
    this.chart.update();
  }
  
  private getColorForCategory(category: string, opacity: number = 1): string {
    // WHY: Consistent colors for each category
    const colors: { [key: string]: string } = {
      temperature: `rgba(59, 130, 246, ${opacity})`,
      sales: `rgba(16, 185, 129, ${opacity})`,
      users: `rgba(245, 158, 11, ${opacity})`,
      revenue: `rgba(139, 92, 246, ${opacity})`
    };
    
    return colors[category] || `rgba(100, 100, 100, ${opacity})`;
  }
}