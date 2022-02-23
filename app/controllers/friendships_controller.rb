class FriendshipsController < ApplicationController
  # before_filter :authenticate_user!
  before_action :find_friendship, :only => [:destroy, :accept]
  before_action :find_user, :only => [:index, :create]

  def index
    @friends = @user.friends
    @pending_invitations = @user.pending_invitations
    @pending_requests = @user.pending_requests
  end

  def create
    return :unprocessable unless @friendship.nil? && @user != current_user

    @friendship = Friendship.new
    @friendship.requestor = current_user
    @friendship.receiver = @user

    if @friendship.save
      # flash[:notice] = "Friend request sent."
      # redirect_to user_path(@user)

      # turbo return
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "friendship_btns",
            partial: "users/friendships/friendship_with_current_user",
            locals: { user: @friendship.receiver }
          )
        }
        format.html { render partial: "users/friendships/friendship_with_current_user", locals: { user: current_user } }
      end
    else
      flash[:error] = "Unable to send friend request."
      redirect_to user_path(@user)
    end
  end

  def destroy
    return :not_found unless @friendship.present?

    @friendship.destroy
    # flash[:notice] = "Friendship destroyed."

    respond_to do |format|
      case params[:view]
      when "invitations_list"
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace(
              "invitations_list",
              partial: "users/friendships/invitations_list",
              locals: { user: @friendship.receiver }
            )
          }
      else
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace(
              "friendship_btns",
              partial: "users/friendships/friendship_with_current_user",
              locals: { user: @friendship.receiver }
            )
          }
      end
      format.html { render partial: "users/friendships/friendship_with_current_user", locals: { user: current_user } }
    end
  end

  def accept
    if @friendship.accept!
    # flash[:notice] = "You are now friends with #{@user.username}."
    # else
    #   flash[:error] = "There was a problem accepting this friendship request."
      respond_to do |format|
        case params[:view]
        when "invitations_list"
            format.turbo_stream {
              render turbo_stream: turbo_stream.replace(
                "invitations_list",
                partial: "users/friendships/invitations_list",
                locals: { user: @friendship.receiver }
              )
            }
        else
            format.turbo_stream {
              render turbo_stream: turbo_stream.replace(
                "friendship_btns",
                partial: "users/friendships/friendship_with_current_user",
                locals: { user: @friendship.receiver }
              )
            }
        end
        format.html { render partial: "users/friendships/friendship_with_current_user", locals: { user: current_user } }
      end
    end

  end

  private

  def find_friendship
    @friendship = Friendship.find(params[:id])
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
