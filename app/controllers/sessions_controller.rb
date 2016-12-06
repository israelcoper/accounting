class SessionsController < Devise::SessionsController
  skip_before_action :current_user_has_account!
  layout 'signin'
end
