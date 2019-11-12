Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/healthcheck', to: 'application#healthcheck'
  get '/issue/new', to: 'issue#show'
  post '/issue/new', to: 'issue#create'
end
