class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]
  authorize_resource
  # GET /user or /user.json
  def index
    return redirect_to root_path unless !current_user.nil?
    dashboardService = DashboardService.new(current_user)
    @more_than_10_mn_today = dashboardService.more_than_10_mn_today?
    @have_3_exercises_today = dashboardService.have_3_exercises_today?
    @each_categories_today = dashboardService.each_categories_today?
  end

  # GET /user/1 or /user/1.json
  def show
  end

  def delete_avatar
    @user = User.find(params[:id])

    # delete avatar
    @user.avatar = nil
    @user.save
    redirect_to edit_user_registration_path, notice: "Avatar was successfully deleted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
