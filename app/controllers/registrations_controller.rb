class RegistrationsController < Devise::RegistrationsController
  layout 'signup'

  protected

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    new_account_path
  end
end
