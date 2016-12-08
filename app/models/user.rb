class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  Role = %w{ admin accountant user }

  scope :non_admin, -> { where.not(role: "admin") }

  belongs_to :account

  validates :username, :first_name, :last_name, :role, presence: true
  validates :username, uniqueness: true

  after_initialize :set_default_role, :if => :new_record?

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
  def set_default_role
    self.role ||= Role.fetch(2)
  end

end
