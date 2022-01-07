class RegistrationsController < Devise::RegistrationsController
  # redirect on update with errors
  def update
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      # redirect to edit with errors
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :avatar)
  end
end
