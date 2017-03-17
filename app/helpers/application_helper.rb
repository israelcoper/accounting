module ApplicationHelper

  def person_type_options
    Person.person_types.keys.map {|key| [key.capitalize, key]}
  end

  def format_date(date)
    return nil if date.nil?
    date.strftime "%d %b %Y"
  end

end
