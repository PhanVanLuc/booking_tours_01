class User < ApplicationRecord
  before_save   :downcase_email
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX =/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-.]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6,
                                                 maximum: 50}, allow_nil: true
  validates :phone_number, presence: true,
                           numericality: { only_integer: true },
                           length: { minimum: 10, maximum: 15 }
  validates :address, presence: true,
                      length: { minimum: 10, maximum: 100 }
  validates :date_of_birth, presence: true                  
  # Returns the hash digest of the given string.
  def User.digest(string)
    if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine::MIN_COST
    else
      cost = BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  private
  
    # Converts email to all lower-case. 
    def downcase_email
      self.email.downcase!
    end
end