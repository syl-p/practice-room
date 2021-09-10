class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  # GET /user or /user.json
  def index
  end

  # GET /user/1 or /user/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
