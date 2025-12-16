# app/controllers/metrics_controller.rb
class MetricsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /metrics
  def index
    # Get optional query parameters for filtering
    category = params[:category]
    hours = params[:hours]&.to_i || 24 # Default to 24 hours

    # Calculate time range
    end_time = Time.current
    start_time = end_time - hours.hours

    # Query metrics with optional filters
    metrics = Metric.by_time_range(start_time, end_time)
    metrics = metrics.where(category: category) if category.present?

    # Render JSON response
    render json: {
      metrics: metrics,
      meta: {
        total: metrics.count,
        category: category,
        time_range: { start: start_time, end: end_time }
      }
    }
  end

  # GET /metrics/latest
  def latest
    latest_metrics = Metric.latest_by_category

    render json: {
      metrics: latest_metrics,
      generated_at: Time.current
    }
  end

  # GET /metrics/stats
  def stats
    stats = Metric.category_stats

    # Transform to more usable format
    category_stats = stats.each_with_object({}) do |stat, hash|
      hash[stat.category] = {
        average: stat.average.to_f.round(2),
        maximum: stat.maximum,
        minimum: stat.minimum
      }
    end

    render json: {
      stats: category_stats,
      generated_at: Time.current
    }
  end

  # POST /metrics
  def create
    metric = Metric.new(metric_params)

    if metric.save
      render json: metric, status: :created
    else
      render json: { errors: metric.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for security
  def metric_params
    params.require(:metric).permit(:value, :category, :timestamp)
  end
end
