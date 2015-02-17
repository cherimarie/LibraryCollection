class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  validates :username, uniqueness: {case_sensitive: false, allow_nil: true, allow_blank: true}
  validates :email, uniqueness: {case_sensitive: false, allow_nil: true, allow_blank: true}
  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true

  has_many :loans
  has_many :books, through: :loans

  MAX_LOANS = 5

  def role
    return roles.first.name.to_sym if roles.first
    nil
  end

  def email_required?
    false
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def good_to_borrow?
    #organization-specific borrowing rules
    self.name && (self.email || self.phone) && (self.identification && !self.identification.blank?) && !self.do_not_lend && self.loans.active.count < 5
  end

  def pref_name
    preferred_first_name || name.split.first
  end

  def self.search(search)
    search_length = search.split.length
    where([(['lower(preferred_first_name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }) +
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" })

  end
end
