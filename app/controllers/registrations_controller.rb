class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)

    if user_params[:password].present?
      update_user_with_password
    else
      update_user_without_password
    end
  end

  private

  def update_user_with_password
    if @user.update_with_password(user_params)
      redirect_after_update
    else
      render_edit_with_errors
    end
  end

  def update_user_without_password
    if @user.update_without_password(user_params)
      redirect_after_update
    else
      render_edit_with_errors
    end
  end

  def redirect_after_update
    set_flash_message :notice, :updated
    redirect_to after_update_path_for(@user)
  end

  def render_edit_with_errors
    render "edit"
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :avatar, :bio, :username)
  end
end
