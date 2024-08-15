class UsersController < ApplicationController
  # before_action :authenticate_admin!, only: [:query_by_param, :admin_update]
  before_action :authenticate_group_manager!, only: [:group_data]
  before_action :set_user_update, only: [:update, :admin_update]
  before_action :set_group, only: [:group_data]
  load_and_authorize_resource :except => [:email_reset_password, :reset_password, :show_reset_token] 

  # GET /user
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user = User.find(params[:id])
  end

  # GET /users/group/1 id of group
  def group_data
    @users = User.where("group_id = ?", @group.id)
    respond_to do |format|
      format.all {render json: @users}
      format.csv { send_data to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  # PATCH/PUT /users/1
  def update
    errors = {}
    update_params.each do |param|
      begin
        @user.update_attribute(param[0], param[1])
      rescue ActiveRecord::InvalidForeignKey
        errors[param[0]] = param[1].to_s + ' não foi encontrado'
      rescue StandardError => msg
        errors[param[0]] = msg
      end
    end
    if errors.length == 0
      @user.update_attribute(:updated_by, current_devise_user.email)
      render json: @user
    else
      render json: {errors: errors, user: @user}, status: :unprocessable_entity
    end
  end
  
  def admin_update
    self.update
  end

  def email_reset_password
    @user = User.find_by_email(params[:email])

    if @user.present?
      aux_code = rand(36**4).to_s(36)
      reset_password_token = rand(36**10).to_s(36)

      @user.update_attribute(:aux_code, aux_code)
      @user.update_attribute(:reset_password_token, reset_password_token)
      UserMailer.reset_password_email(@user).deliver
      render json: {message: "Email enviado com sucesso"}, status: :ok
    else
      render json: {error: true, message: "Email não encontrado"}, status: :bad_request
    end
  end

  def show_reset_token
    user = User.where(aux_code: params[:code]).first
    if user.present?
      render json: {reset_password_token: user.reset_password_token}, status: :ok
    else
      render json: {error: true, message: "Codigo invalido"}, status: :bad_request
    end
  end

  def reset_password
    @user = User.where(reset_password_token: params[:reset_password_token]).first
    if @user.present?
      if @user.reset_password(params[:password], params[:password_confirmation])
        render json: {error: false, message: "Senha redefinida com sucesso"}, status: :ok
      else
        render json: {error: true, data: @user.errors}, status: :bad_request
      end
    else
      render json: {error: true, message: "Token invalido"}, status: :bad_request
    end
  end

  def request_deletion
    @user = User.find(params[:id])

    if @user.present?
      UserMailer.request_deletion_email(@user).deliver
      render json: {message: "Email enviado com sucesso"}, status: :ok
    else
      render json: {error: true, message: "Usuário não encontrado"}, status: :bad_request
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:deleted_by, current_devise_user.email)
    @user.destroy!
  end

  def query_by_param
    param_to_search = params[:param_to_search]
    param_content = params[:param_content]
    if param_to_search == "gender"
      @users = User.where(gender: param_content)
    elsif param_to_search == "race"
      @users = User.where(race: param_content)
    elsif param_to_search == "is_professional"
      @users = User.where(is_professional: param_content)
    elsif param_to_search == "country"
      @users = User.where(country: param_content)
    elsif param_to_search == "name"
      @users = User.where(user_name: param_content)
    end
    
    render json: @users
  end
  
  def panel_list
    @current_user = current_devise_user

    if !current_city_manager.nil?
      if params[:email]
        query_regex = "^" + params[:email]
        @user = User.where(city: current_city_manager.city).where('email ~* ?', query_regex)
      else
        @user = User.where(city: current_city_manager.city)
      end
    elsif params[:email]
      query_regex = "^" + params[:email]
      if !current_group_manager.nil?
        @groups = Group.where(group_manager_id: @current_user.id).ids
        @user = User.where(group_id: @groups).where('email ~* ?', query_regex)
      else
        @user =  User.user_by_app_id(@current_user.app_id).where('email ~* ?', query_regex)
      end
    elsif params[:identification_code]
      query_regex = "^" + params[:identification_code]
      if !current_group_manager.nil?
        @groups = Group.where(group_manager_id: @current_user.id).ids
        @user = User.where(group_id: @groups).where('identification_code ~* ?', query_regex)
      else
        @user =  User.user_by_app_id(@current_user.app_id).where('identification_code ~* ?', query_regex)
      end
    else
      if !current_group_manager.nil?
        @groups = Group.where(group_manager_id: @current_user.id).ids
        @user = User.where(group_id: @groups)
      elsif !current_group_manager_team.nil?
        @groups = Group.where(group_manager_id: @current_user.group_manager_id).ids
        @user = User.where(group_id: @groups)
      else
        @user = User.user_by_app_id(@current_user.app_id)
      end 
    end

    paginate @user, per_page: 50
  end

  def filtered_list
    @current_user = current_devise_user

    if !current_admin.nil?
      if current_admin.is_god
        @user = User.ransack(params[:filters]).result
      else
        @user = User.user_by_app_id(@current_user.app_id).ransack(params[:filters]).result
      end
    elsif !current_group_manager.nil?
      @groups = Group.where(group_manager_id: @current_user.id).ids
      @user = User.where(group_id: @groups).ransack(params[:filters]).result
    elsif !current_group_manager_team.nil?
      @groups = Group.where(group_manager_id: @current_user.group_manager_id).ids
      @user = User.where(group_id: @groups).ransack(params[:filters]).result
    else 
      @user = User.user_by_app_id(@current_user.app_id).ransack(params[:filters]).result
    end

    paginate @user, per_page: 50
  end

  def ranking
    @users_ranked = User.order(streak: :desc, updated_at: :desc).limit(15)

    render json: @users_ranked, each_serializer: UserRankingSerializer
  end

private
  def to_csv
    attributes = []
    @users.first.search_data.each do |key, value|
      attributes.append(key)
    end

    CSV.generate(headers: true) do |csv|
      csv << attributes
      @users.each do |user|
        csv << user.search_data.map { |key, value| value.to_s }
      end
    end
  end

  def set_group
    @group = Group.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    # if current_user.id != params[:id]
    #   render json: { errors: [
    #     detail: I18n.t("user.access_forbiden")
    #   ]}
    # else
    #   @user = User.find(current_user.id)
    # end
    @user = User.find(params[:id])
  end

  def set_user_update
    @user = User.find(params[:id])
  end
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(
      :user_name,
      :email, 
      :birthdate, 
      :country, 
      :gender, 
      :race, 
      :is_professional, 
      :app_id, 
      :password, 
      :picture, 
      :city, 
      :identification_code, 
      :state, 
      :group_id, 
      :risk_group, 
      :policy_version,
      :first_dose_date,
      :second_dose_date,
      :vaccine_id,
      :category_id
    )
  end

  def update_params
    params.require(:user).permit(
      :user_name,
      :birthdate,
      :gender,
      :race,
      :residence,
      :country,
      :state,
      :city,
      :identification_code,
      :group_id,
      :risk_group,
      :policy_version,
      :is_professional,
      :is_vbe,
      :in_training,
      :is_vigilance, 
      :phone, 
      :first_dose_date,
      :second_dose_date,
      :vaccine_id,
      :category_id
    )
  end

end
