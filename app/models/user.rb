class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  Role = %w{ admin accountant user }

  belongs_to :account

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    [first_name, last_name].join " "
  end
end
