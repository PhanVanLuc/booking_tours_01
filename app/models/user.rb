class User < ApplicationRecord
  has_many :bookings
  has_many :tours, through: :bookings
  has_many :reviews, dependent: :destroy
  has_many :like_reviews, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, class_name: Notification.name,
                        foreign_key: :receiver_id, dependent: :destroy
  has_many :send_notifications, class_name: Notification.name,
                        foreign_key: :sender_id, dependent: :destroy

  devise :database_authenticatable,
         :recoverable, :trackable, :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2, :twitter]
  before_save   :downcase_email
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX =/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-.]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6,
                                                 maximum: 50},
                       confirmation: true,
                       allow_blank: true,
                       on: :update
  validates :password, presence: true, length: { minimum: 6,
                                                maximum: 50},
                       confirmation: true,
                       on: :create
  validates :phone_number, presence: true,
                           numericality: { only_integer: true },
                           length: { minimum: 10, maximum: 15 }, allow_nil: true
  validates :address, presence: true,
                      length: { minimum: 10, maximum: 100 }, allow_nil: true
  validates :date_of_birth, presence: true, allow_nil: true
  scope :name_like, ->(name){where "name LIKE ?", "%#{name}%"}
  # search tour
  def self.search(term)
    if term
      User.name_like term
    else
      all
    end
  end
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
    Devise::Encryptor.digest(digest, token)
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Generate data from the social
  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user.nil?
      password = Devise.friendly_token[0,20]
      user = User.create!(provider: auth.provider,
                          uid: auth.uid,
                          email: auth.info.email,
                          name: auth.info.name,
                          password: password,
                          password_confirmation: password)
    end
    user
  end

  after_create do
    customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: customer.id)
  end
  
  private
  
    # Converts email to all lower-case. 
    def downcase_email
      self.email.downcase!
    end
end
