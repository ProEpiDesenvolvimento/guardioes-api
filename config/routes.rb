Rails.application.routes.draw do
  resources :categories
  resources :form_answers
  resources :form_options
  resources :form_questions
  resources :forms
  resources :twitter_apis
  resources :pre_registers
  resources :messages
  resources :syndromes
  resources :permissions, only: [:create, :update, :show, :destroy]
  resources :vaccines
  resources :doses

  get "flexible_forms/registration/:app_id", to: "flexible_forms#registration"
  get "flexible_forms/signal", to: "flexible_forms#signal"
  get "flexible_forms/quizzes", to: "flexible_forms#quizzes"
  resources :flexible_answers
  resources :flexible_form_versions
  resources :flexible_forms

  get "groups/root", to: "groups#root"
  post "groups/build_country_city_state_groups", to: "groups#build_country_city_state_groups"
  post "groups/upload_group_file", to: "groups#upload_group_file"
  get "groups/:id/get_path", to: "groups#get_path"
  get "groups/:id/get_children", to: "groups#get_children"
  get "groups/:id/get_twitter", to: "groups#get_twitter"
  resources :groups

  get "data_visualization/users_count", to: "data_visualizations#users_count"
  get "data_visualization/surveys_count", to: "data_visualizations#surveys_count"
  get "data_visualization/asymptomatic_surveys_count", to: "data_visualizations#asymptomatic_surveys_count"
  get "data_visualization/symptomatic_surveys_count", to: "data_visualizations#symptomatic_surveys_count"
  post "data_visualization/metabase_urls", to: "data_visualizations#metabase_urls"
  
  resources :symptoms
  resources :contents

  get "apps/:id/get_twitter", to: "apps#get_twitter"
  resources :apps

  resources :rumors

  get "surveys/school_unit/:id", to: "surveys#group_data"
  get "users/school_unit/:id", to: "users#group_data"

  #get "surveys/all_surveys", to: "surveys#all_surveys"
  get "surveys/group_cases", to: "surveys#group_cases"
  #get "surveys/week", to: "surveys#weekly_surveys"
  get "surveys/week", to: "surveys#limited_surveys"
  get "surveys/render_without_user", to: "surveys#render_without_user"
  #get "surveys/to_csv/:begin/:end/:key", to: "surveys#surveys_to_csv"
  post "email_reset_password", to: "users#email_reset_password"
  post "show_reset_token", to: "users#show_reset_token"
  post "reset_password", to: "users#reset_password"

  resources :users do
    resources :households
    resources :surveys
  end
  post "render_user_by_filter",to: "users#query_by_param"
  patch "admin_update/:id", to: "users#admin_update"

  scope "/user" do 
    get "/panel", to: "users#panel_list"
    post "/filtered_list", to: "users#filtered_list"
    get "/ranking", to: "users#ranking"
    get "/request_deletion/:id", to: "users#request_deletion"
  end

  scope "/admin" do 
    post "email_reset_password", to: "admins#email_reset_password"
    post "show_reset_token", to: "admins#show_reset_token"
    post "reset_password", to: "admins#reset_password"
  end
  resources :admins, only: [:index, :show, :update, :destroy]
  
  devise_for :admins,
    path: "/admin",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: "session",
      registrations: "registration"
    }

  resources :city_managers
  scope "/city_manager" do 
    post "email_reset_password", to: "city_managers#email_reset_password"
    post "show_reset_token", to: "city_managers#show_reset_token"
    post "reset_password", to: "city_managers#reset_password"
  end
  devise_for :city_managers,
    path: "/city_manager",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: "session",
      registrations: "registration"
    }

    resources :group_managers
    #get "group_managers/:group_manager_id/:group_id", to: "group_managers#is_manager_permitted"
    scope "/group_manager" do 
      post "email_reset_password", to: "group_managers#email_reset_password"
      post "show_reset_token", to: "group_managers#show_reset_token"
      post "reset_password", to: "group_managers#reset_password"
    end
    # IN THE FUTURE THE FOLLOWING FUTURES WILL BE IMPLEMENTED
    # get "group_managers/:manager_id/:group_id/permit", to: "group_managers#add_manager_permission"
    # get "group_managers/:manager_id/:group_id/unpermit", to: "group_managers#remove_manager_permission"
    devise_for :group_managers,
    path: "/group_manager",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: "session",
      registrations: "registration"
    }

    resources :group_manager_teams
    scope "/group_manager_team" do 
      post "email_reset_password", to: "group_manager_teams#email_reset_password"
      post "show_reset_token", to: "group_manager_teams#show_reset_token"
      post "reset_password", to: "group_manager_teams#reset_password"
    end
    devise_for :group_manager_teams,
      path: "/group_manager_team",
      path_names: {
        sign_in: "login",
        sign_out: "logout",
        registration: "signup"
      },
      controllers: {
        sessions: "session",
        registrations: "registration",
      }

    resources :managers
    scope "/manager" do 
      post "email_reset_password", to: "managers#email_reset_password"
      post "show_reset_token", to: "managers#show_reset_token"
      post "reset_password", to: "managers#reset_password"
    end
    devise_for :managers,
      path: "/manager",
      path_names: {
        sign_in: "login",
        sign_out: "logout",
        registration: "signup"
      },
      controllers: {
        sessions: "session",
        registrations: "registration",
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
  get '/flexible_answers/:id/signal_comments', to: 'flexible_answers#signal_comments'
  post '/flexible_answers/:id/signal_comments', to: 'flexible_answers#create_signal_comments'
end
