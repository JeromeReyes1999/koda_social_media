Rails.application.routes.draw do
  devise_for :users
  resources :posts, except: :show do
    resources :comments
  end

  resources :friend_requests, only: [:index, :create]  do
    put :accept, to: 'friend_requests#accept'
    delete :decline, to: 'friend_requests#decline'
    delete :unfriend, to: 'friend_requests#unfriend'
    delete :cancel, to: 'friend_requests#cancel'
  end

  root :to => 'posts#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
