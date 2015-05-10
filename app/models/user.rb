class User < ActiveRecord::Base
  include UserSerializer
  has_secure_password

  # relations
  has_many :posts
  has_many :replies

  # callbacks
  before_validation :downcase_email

  # validations
  validates :password,
            confirmation: true,
            length: { minimum: 6 },
            if: :password
  validates :username,
            uniqueness: {case_sensitive: false},
            format: { with: /\A[a-zA-Z0-9]+\Z/, message: 'may only consist of letters and numbers' },
            length: {minimum: 3, maximum: 255}
  validates :email,
            uniqueness: true,
            format: { with: /@/, message: "must contain the '@' symbol" },
            length: {minimum: 3, maximum: 255}

  class << self
    def active
      where(arel_table[:deactivated_at].eq(nil))
    end

    def deactive
      where(arel_table[:deactivated_at].not_eq(nil))
    end

    def find_by_downcased_username(username)
      where("lower(username) = ?", username).first
    end
  end

  def deactivate!
    self.deactivated_at = Time.now
    save
  end

  def active
    deactivated_at.blank?
  end

  def role_name
    if new_record?
      'New'
    elsif admin?
      'Admin'
    else
      'Normal'
    end
  end


  private

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
end