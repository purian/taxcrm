Rails.application.routes.draw do
  root 'leads#index'
  get 'leads', to: 'leads#index'
  get 'leads/filter', to: 'leads#filter'
  get 'leads/details', to: 'leads#details'
  get 'leads/show_leads', to: 'leads#show_leads'
  
  get 'charts/index'
  get 'charts', to: 'charts#index'
  get 'sales/index'
  get 'leads_dashboard', to: 'leads_dashboard#index'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get 'field_data/new', to: 'field_data#new', as: 'new_field_data'
  post 'field_data/decode', to: 'field_data#decode'
  
  resources :external_data, only: [:index, :create]
  get 'external_data/all_details', to: 'external_data#all_external_details', as: 'all_external_details'
  post 'sync_external_details', to: 'external_details#sync_to_crm'
end
