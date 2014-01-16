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
        get :autocomplete
      end
    end

    resources :top_ups do
      collection do
        get :top_up
        get :phone_number
        get :contact
        post :create_contact
        post :create_phone_number
      end
    end

    resources :wallets do
      collection do
        post :deposit
        post :pay
      end
    end

    resources :contact_groups

    resources :orders, only:[:index,:destroy,:show] do
      member do
        post :pay
        post :confirm
        post :cancel
        get :check_status
      end
      collection { post :search, to: 'orders#index' }
    end

  end




  resources :feedback_messages ,:only => [:create]
  post '/interswitch_notify' => 'interswitch_notification#interswitch_notify', as: :interswitch_notify
  get '/interswitch_notify' => 'interswitch_notification#show_interswitch_order_status', as: :show_interswitch_order_status

  get "home/index"
  root :to => "home#index"
end
