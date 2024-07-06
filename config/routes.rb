Rails.application.routes.draw do
  root to: 'charts#index'
  get 'charts/index'
  get 'charts', to: 'charts#index'
  get 'sales/index'
  get 'leads_dashboard', to: 'leads_dashboard#index'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
end
