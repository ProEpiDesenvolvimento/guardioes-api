Rails.application.routes.draw do
  resources :symptoms
  resources :public_hospitals
  resources :contents
  resources :apps

  get "surveys/all_surveys", to: "surveys#all_surveys"

  resources :user
  resources :user do
    resources :households
    resources :surveys
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

    devise_for :users,
      path: "/user",
      path_names: {
        sign_in: "login",
        sign_out: "logout",
        registration: "signup"
      },
      controllers: {
        sessions: "session",
        registrations: "registration"
      }

    root to: "admin#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
