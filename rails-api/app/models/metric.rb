# app/models/metric.rb
class Metric < ApplicationRecord
  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :category, presence: true
  validates :timestamp, presence: true

  # Class methods for business logic
  class << self
    # Get latest metrics (one per category)
    def latest_by_category
      # SQL query to get the most recent metric for each category
      query = <<-SQL
        SELECT DISTINCT ON (category) *
        FROM metrics
        ORDER BY category, timestamp DESC
      SQL

      find_by_sql(query)
    end

    # Get metrics for a specific time range
    def by_time_range(start_time, end_time)
      where(timestamp: start_time..end_time).order(:timestamp)
    end

    # Get statistics by category
    def category_stats
      # SQL aggregation for performance
      select('category, AVG(value) as average, MAX(value) as maximum, MIN(value) as minimum')
        .group(:category)
    end
  end
end
