# rails-api/Dockerfile

# Multi-stage build for Rails
FROM ruby:3.1.2-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git \
    tzdata

# Set working directory
WORKDIR /app

# Copy Gemfile first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems without development and test groups
RUN bundle install --jobs 4 --retry 3 --without test development

# Copy application code
COPY . .

# Runtime stage
FROM ruby:3.1.2-alpine

# Install runtime dependencies only
RUN apk add --no-cache \
    postgresql-client \
    nodejs \
    tzdata

# Create non-root user
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

# Set working directory
WORKDIR /app

# Copy installed gems from builder stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app

# Set proper ownership
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Expose port
EXPOSE 3000

# Start Rails server
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
