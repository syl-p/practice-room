class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

=begin
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
=end

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :avatar)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :current_password, :avatar, :bio)}
  end

  protected
  def set_categories
    @categories = Category.all
  end

  def set_exercises_filtered
    @exercises = Exercise.for_current_user(current_user)
  end
end
