Qwiqar::Application.routes.draw do

  devise_for :users, path_prefix: "account", path_names: {sign_in: "login", sign_out: "logout" }, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  as :user do
    match "account/users/sign_out", :to => "devise/sessions#destroy" ,:as=>"user_sign_out"
    match '/user/home', :to => 'users#home',:as=> "user_root"
  end

  resources :users   do
    member do
      get :profile
      get :people
    end

    resources :contacts do
      collection do
        get :search
      end
    end

    resources :top_ups do
      collection do
        get :top_up
      end
    end

    resources :wallets do
      collection do
        get :top_up
      end
    end

    resources :contact_groups
  end


  resources :orders

  resources :feedback_messages ,:only => [:create]

  get "home/index"
  root :to => "home#index"
end
