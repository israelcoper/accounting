module UserPersonHelper
  extend ActiveSupport::Concern

  def full_name
    [first_name, last_name].join " "
  end
end
