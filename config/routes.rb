Rails.application.routes.draw do
  get 'admins/', to: "admin#index"
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

    root to: "admin#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
