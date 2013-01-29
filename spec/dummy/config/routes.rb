TestAsk::Application.routes.draw do
  
  resources :forms do
    resources :submissions
  end
  
  root :to => 'forms#index'
end
