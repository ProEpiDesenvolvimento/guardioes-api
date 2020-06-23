Rails.application.routes.draw do
  resources :syndromes
  resources :school_units
  post "upload_by_file", to: 'school_units#upload_by_file'
  
  resources :groups
  get "dashboard", to: 'dashboard#index'
  
  resources :symptoms
  resources :public_hospitals
  post "public_hospital_admin", to: "public_hospitals#render_public_hospital_admin"
  resources :contents
  resources :apps
  resources :rumors

  get "surveys/all_surveys", to: "surveys#all_surveys"
  #get "surveys/week", to: "surveys#weekly_surveys"
  #get "surveys/week_limited", to: "surveys#limited_surveys"
  get "surveys/week", to: "surveys#limited_surveys"
  get "surveys/render_without_user", to: "surveys#render_without_user"
  post "email_reset_password", to: "users#email_reset_password"
  post "show_reset_token", to: "users#show_reset_token"
  post "reset_password", to: "users#reset_password"

  get "/googlemapsapikey", to: "googlemapsapikey#index"
  
  resources :users do
    resources :households
    resources :surveys
  end
  post "render_user_by_filter",to: "users#query_by_param"


  resources :rumors

  scope "/user" do 
    post "reset_password", to: "users#reset_password"
  end

  devise_for :admins,
    path: 'admin/',
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: 'session',
      registrations: 'registration'
    }

    resources :managers
    devise_for :managers,
    path: 'manager/',
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: 'session',
      registrations: 'registration'
    }

    devise_for :users,
      path: "/user",
      path_names: {
        sign_in: "login",
        sign_out: "logout",
        registration: "signup"
      },
      controllers: {
        sessions: "session",
        registrations: "registration",
        # passwords: "passwords"
      }

    root to: "admin#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
