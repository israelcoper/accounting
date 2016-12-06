class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :current_user_has_account!

  def current_user_has_account!
    redirect_to new_account_path if user_signed_in? && current_user.account.nil?
  end
end
