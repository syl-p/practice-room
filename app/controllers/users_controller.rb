class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]
  layout "layouts/dashboard", only: %i[index]
  authorize_resource
  # GET /user or /user.json
  def index
    redirect_to root_path unless current_user.present?
    @practices_of_the_week = current_user.practices.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
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
