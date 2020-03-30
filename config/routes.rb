Rails.application.routes.draw do
  resources :groups
  get "dashboard", to: 'dashboard#index'
  
  resources :symptoms
  resources :public_hospitals
  post "public_hospital_admin", to: "public_hospitals#render_public_hospital_admin"
  resources :contents
  resources :apps

  get "surveys/all_surveys", to: "surveys#all_surveys"

  resources :users do
    resources :households
    resources :surveys
  end
  post "render_user_by_filter",to: "users#query_by_param"

  resources :rumors
  
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
