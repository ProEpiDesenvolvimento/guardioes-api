class AdminController < ApplicationController
  before_action :authenticate_admin!
  def index
    @admins = Admin.all
    render json: @admins
  end
end
