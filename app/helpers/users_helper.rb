module UsersHelper

  def role_options
    User::Role.map {|role| [role.capitalize, role]}
  end

end
