Rails.application.routes.draw do
  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
  
    resources :forms do
      resources :submissions, :only=>:index
    end
    resources :all_forms, :controller=>:forms, :only=>[] do
      resources :submissions, :only=>[:create, :update]
    end
    resources :submissions, :only=>[:show, :edit]
  
  end
end
