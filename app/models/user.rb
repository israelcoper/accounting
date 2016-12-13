class User < ActiveRecord::Base
  include PgSearch
  include UserPersonHelper
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

  paginates_per 10

  pg_search_scope :search, against: [:first_name, :last_name, :username]

  def email_required?
    false
  end

  def email_changed?
    false
  end

  protected
end
