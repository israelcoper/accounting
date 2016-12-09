module UsersHelper

  def role_options
    User.roles.keys.reject {|key| key.eql?("admin")}.map {|key| [key.capitalize, key]}
  end

end
