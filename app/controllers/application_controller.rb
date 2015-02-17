class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session
    before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit( :username, :email, :password, :password_confirmation, :remember_me,
                :name, :preferred_first_name, :address, :city, :state, :zip, :phone)
    end
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :current_password, :preferred_first_name, :address, :city, :state, :zip, :phone)
    end
  end
end
