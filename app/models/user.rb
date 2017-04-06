class User < ActiveRecord::Base
  include PgSearch
  include UserPersonHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable,
         :authentication_keys => [:username]

  enum role: [:normal, :accountant, :admin]

  default_scope { order("first_name ASC") }

  scope :non_admin, -> { where.not(role: 2) }

  belongs_to :account
  has_many :activities, dependent: :destroy

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

  def locked
    self.failed_attempts = 3
    self.locked_at = Time.zone.now
    self.save
    return locked_at
  end

  def unlocked
    self.failed_attempts = 0
    self.locked_at = nil
    self.save
    return locked_at
  end

  def locked?
    failed_attempts == 3 && locked_at.present?
  end

  protected
end
