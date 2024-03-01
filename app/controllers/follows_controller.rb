class FollowsController < ApplicationController
  before_action :find_user, :only => [:create, :destroy]
  before_action :find_follow, :only => [:create, :destroy]

  def create
    return :unprocessable unless @user != current_user

    @follow = Follow.new
    @follow.follower = current_user
    @follow.following = @user
    @follow.save

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "follow_btn",
          partial: "users/follows/btn",
          locals: { user: @follow.following }
        )
      }
    end
  end

  def destroy
    return :not_found unless @follow.present?
    @follow.destroy

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "follow_btn",
          partial: "users/follows/bell",
          locals: { user: @user }
        )
      }
    end
  end

  private

  def find_follow
    @follow = current_user.follows_as_following.find_by(following_id: params[:id])
  end

  def find_user
    @user = User.find(params[:id])
  end
end
