class SessionsController < Devise::SessionsController
  skip_before_action :current_user_has_account!
  skip_before_action :current_account_has_account_chart!
  layout 'signin'
end
