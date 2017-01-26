class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :current_user_has_account!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

    def current_account
      @current_account ||= current_user.account
    end
    helper_method :current_account

    def current_account?
      if params[:controller].eql?("accounts")
        params[:id].to_i == current_account.id
      else
        params[:account_id].to_i == current_account.id
      end
    end
    helper_method :current_account?

    def pundit_user
      UserContext.new(current_user, current_account?)
    end

    def current_user_has_account!
      redirect_to new_account_path if user_signed_in? && current_user.account.nil?
    end

    def after_sign_in_path_for(resource)
      root_path
    end

    def after_sign_out_path_for(resource_or_scope)
      signin_path
    end

    def page
      params[:page] ||= 1
    end

    def transaction_filter
      if params[:filter].present?
        params[:filter].eql?("All") ? Transaction::Status : params[:filter]
      else
        Transaction::Status
      end
    end

  private

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
