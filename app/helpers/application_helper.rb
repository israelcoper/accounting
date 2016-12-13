module ApplicationHelper

  def person_type_options
    Person.person_types.keys.map {|key| [key.capitalize, key]}
  end

end
