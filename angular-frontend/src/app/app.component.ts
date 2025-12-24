// src/app/app.component.ts
import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

interface Metric {
  id: number;
  value: number;
  category: string;
  timestamp: string;
}

@Component({
  selector: 'app-root',
  template: `
    <div class="container">
      <h1>Metrics Dashboard</h1>
      <button (click)="refresh()" [disabled]="loading">
        {{ loading ? 'Loading...' : 'Refresh' }}
      </button>
      
      <div *ngIf="error" class="error">{{ error }}</div>
      
      <h2>Latest Metrics</h2>
      <div class="metrics-grid">
        <div *ngFor="let metric of latestMetrics" class="metric-card">
          <h3>{{ metric.category }}</h3>
          <div class="value">{{ metric.value }}</div>
          <div class="time">{{ formatTime(metric.timestamp) }}</div>
        </div>
      </div>
      
      <h2>Recent History</h2>
      <div class="history">
        <div *ngFor="let metric of metrics" class="history-item">
          <span>{{ metric.category }}</span>
          <span>{{ metric.value }}</span>
          <span>{{ formatTime(metric.timestamp) }}</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .container {
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
      font-family: Arial, sans-serif;
    }
    
    h1 {
      color: #333;
      text-align: center;
    }
    
    button {
      display: block;
      margin: 20px auto;
      padding: 10px 20px;
      background: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
    }
    
    button:disabled {
      background: #ccc;
      cursor: not-allowed;
    }
    
    .error {
      background: #f8d7da;
      color: #721c24;
      padding: 10px;
      border-radius: 5px;
      margin: 20px 0;
      text-align: center;
    }
    
    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin: 20px 0;
    }
    
    .metric-card {
      padding: 20px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      text-align: center;
    }
    
    .metric-card h3 {
      margin: 0 0 10px 0;
      color: #666;
      text-transform: uppercase;
    }
    
    .metric-card .value {
      font-size: 36px;
      font-weight: bold;
      color: #333;
      margin: 10px 0;
    }
    
    .metric-card .time {
      color: #888;
      font-size: 12px;
    }
    
    .history {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      padding: 20px;
    }
    
    .history-item {
      display: flex;
      justify-content: space-between;
      padding: 10px;
      border-bottom: 1px solid #eee;
    }
    
    .history-item:last-child {
      border-bottom: none;
    }
    
    .history-item span:first-child {
      font-weight: bold;
      color: #007bff;
    }
    
    .history-item span:nth-child(2) {
      font-weight: bold;
      color: #333;
    }
    
    .history-item span:last-child {
      color: #888;
      font-size: 14px;
    }
  `]
})
export class AppComponent implements OnInit {
  metrics: Metric[] = [];
  latestMetrics: Metric[] = [];
  loading = false;
  error: string | null = null;
  constructor(private http: HttpClient) {}

  apiBaseUrl = (window as any).API_BASE_URL || 'http://localhost:3000';

  ngOnInit() {
    this.loadData();
  }

  loadData() {
    this.loading = true;
    this.error = null;
    
    setTimeout(() => {
      this.loading = false;
      
      this.http.get<any>(`${this.apiBaseUrl}/api/metrics`).subscribe({
        next: (response) => {
          this.metrics = response.metrics;
          this.loading = false;
        },
        error: (err) => {
          this.error = 'Failed to load data: ' + err.message;
          this.loading = false;
        }
      });
      
      this.http.get<any>(`${this.apiBaseUrl}/api/metrics/latest`).subscribe({
        next: (response) => {
          this.latestMetrics = response.metrics;
        }
      });
    }, 1000);
  }

  refresh() {
    this.loadData();
  }

  formatTime(timestamp: string): string {
    const date = new Date(timestamp);
    return date.toLocaleTimeString([], { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
  }
}