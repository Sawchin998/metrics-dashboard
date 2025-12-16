Rails.application.routes.draw do
  resources :metrics, only: [:index, :create] do
    collection do
      get :latest    # /metrics/latest
      get :stats     # /metrics/stats
    end
  end

  # Health check endpoint
  get :health, to: ->(env) { [200, {}, ['OK']] }

  # Root endpoint
  root to: ->(env) { [200, {}, ['Metrics API']] }
end
