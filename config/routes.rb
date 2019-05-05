Rails.application.routes.draw do
  devise_for :user, path: 'admin/'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'application#index'

  scope '/admin' do
    resources :pages
  end
end
