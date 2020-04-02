class ManagersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_app
    
    def index
        render json: @app.managers
    end

    private

    def set_app
        @app = App.find current_admin.app_id
    end
end