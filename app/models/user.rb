class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  enum role: [:normal, :accountant, :admin]

  scope :non_admin, -> { where.not(role: 2) }

  belongs_to :account

  validates :username, :first_name, :last_name, :role, presence: true
  validates :username, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    [first_name, last_name].join " "
  end

  protected
end
