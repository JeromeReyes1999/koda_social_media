Rails.application.routes.draw do
  devise_for :users
  resources :posts, except: :show do
    resources :comments
  end

  resources :friend_requests, only: [:index, :create] do
    put :accept, to: 'friend_requests#accept'
    delete :decline, to: 'friend_requests#decline'
    delete :unfriend, to: 'friend_requests#unfriend'
    delete :cancel, to: 'friend_requests#cancel'
  end

  resources :user_groups, only: :index do
    put :accept, to: 'user_groups#accept'
    put :leave, to: 'user_groups#leave'
    put :approve, to: 'user_groups#approve'
    put :decline, to: 'user_groups#decline'
    put :change_role, to: 'user_groups#change_role'
    put 'change_suspension/:is_suspended', as: :change_suspension, to: 'user_groups#change_suspension'
    put :remove, to: 'user_groups#remove'
  end

  resources :groups, except: :index do
    resources :posts, except: :index, controller: "group_posts" do
      resources :comments
      put :remove, to: 'group_posts#remove'
      get :show_remove, to: 'group_posts#show_remove'
      put :reject, to: 'group_posts#reject'
      put :publish, to: 'group_posts#publish'
    end
    post :join, to: 'groups#join'
    get :home
    post 'invite/:user_id', as: :invite, to: 'groups#invite'
    get :invite_friends, to: 'groups#invite_friends'
    get :member_management, to: 'groups#member_management'
    get :post_management, to: 'groups#post_management'
    put 'change_privacy/:privacy', as: :change_privacy, to: 'groups#change_privacy'
  end

  root :to => 'posts#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
