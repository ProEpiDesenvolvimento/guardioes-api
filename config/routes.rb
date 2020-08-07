Rails.application.routes.draw do
  resources :pre_registers
  resources :messages
  resources :syndromes
  resources :school_units
  post "school_units_list", to: 'school_units#index_filtered'
  post "upload_by_file", to: 'school_units#upload_by_file'
  
  get "groups/root", to: 'groups#root'
  post '/groups/build_country_city_state_groups', to: 'groups#build_country_city_state_groups'
  post "groups/upload_group_file", to: 'groups#upload_group_file'
  get "groups/:id/get_path", to: 'groups#get_path'
  get "groups/:id/get_children", to: 'groups#get_children'
  get "groups/:id/get_twitter", to: 'groups#get_twitter'
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

    resources :group_managers
    get 'group_managers/:group_manager_id/:group_id', to: 'group_managers#is_manager_permitted'
    # IN THE FUTURE THE FOLLOWING FUTURES WILL BE IMPLEMENTED
    # get 'group_managers/:manager_id/:group_id/permit', to: 'group_managers#add_manager_permission'
    # get 'group_managers/:manager_id/:group_id/unpermit', to: 'group_managers#remove_manager_permission'
    devise_for :group_managers,
    path: 'group_manager/',
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
