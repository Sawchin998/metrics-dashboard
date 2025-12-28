Rails.application.routes.draw do
  scope :api do
    resources :metrics, only: %i[index create] do
      collection do
        get :latest    # /metrics/latest
        get :stats     # /metrics/stats
      end
    end

    # Health check endpoint
    get :health, to: ->(_env) { [200, {}, ['OK']] }

    root to: ->(_env) { [200, {}, ['Metrics API']] }
  end
end
