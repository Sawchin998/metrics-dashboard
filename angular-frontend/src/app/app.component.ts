// src/app/app.component.ts
import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { MetricsService } from './services/metrics.service';
import { Metric } from './models/metric.model';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, OnDestroy {
  metrics: Metric[] = [];
  latestMetrics: Metric[] = [];
  stats: any = {};
  
  private refreshInterval: any;
  
  constructor(private metricsService: MetricsService) {}
  
  ngOnInit() {
    this.loadData();
    this.startAutoRefresh();
  }
  
  ngOnDestroy() {
    this.stopAutoRefresh();
  }
  
  // Load all necessary data

  loadData() {
    this.loadMetrics();
    this.loadLatestMetrics();
    this.loadStats();
  }
  
  // Load historical metrics for charts
  loadMetrics() {
    this.metricsService.getMetrics().subscribe({
      next: (response) => {
        this.metrics = response.metrics;
      },
      error: (error) => {
        console.error('Error loading metrics:', error);
      }
    });
  }
  
  // Load latest metrics for real-time display
  loadLatestMetrics() {
    this.metricsService.getLatestMetrics().subscribe({
      next: (response) => {
        this.latestMetrics = response.metrics;
      },
      error: (error) => {
        console.error('Error loading latest metrics:', error);
      }
    });
  }
  
  // Load statistics for summary
  loadStats() {
    this.metricsService.getStats().subscribe({
      next: (response) => {
        this.stats = response.stats;
      },
      error: (error) => {
        console.error('Error loading stats:', error);
      }
    });
  }
  
  // Start automatic data refresh
  startAutoRefresh() {
    this.refreshInterval = setInterval(() => {
      this.loadLatestMetrics();
      this.loadStats();
    }, 10000); // Refresh every 10 seconds
  }
  
  // Stop automatic refresh
  stopAutoRefresh() {
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
  }
  
  // Manual refresh button handler
  onRefresh() {
    this.loadData();
  }
}