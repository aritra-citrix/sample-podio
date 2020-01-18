Rails.application.routes.draw do
  get '/display', to: 'main_page#display'
  get '/callback', to: 'main_page#callback'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
