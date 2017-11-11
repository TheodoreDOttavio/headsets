class User < ActiveRecord::Base
  # this is a test for memmory objects, not database entries so a double submit will still create two entries that are the same
  #  need to implement at the database level as well

  #  also for uniqueness, downcase the email before saving it to the db
  before_save { self.email = email.downcase }

  # For User Tokens, adds one before the user create route is triggered:
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  # study regex here: http://www.rubular.com/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # uniqueness: true works, but it is not sensitive to case... so:
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # to add password and password_confirmation attributes, require the presence of
  #  the password, require that they match, and add an authenticate method to
  #  compare a hashed password to the password_digest to authenticate users.
  #  This is the only nontrivial step, and in the latest version of Rails
  #  all these features come for free with one method, has_secure_password:

  has_secure_password
  validates :password, length: { minimum: 6 }

  # the next two methods are left public so they can be used elsewhere

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
    # SHA1 is faster than Bcrypt
    # .to_s to string is to prevent the nil formed by ""
  end

  private

  def create_remember_token
    self.remember_token = User.hash(User.new_remember_token)
    # The self object makes this NOT a local variable so it is written to the db
  end
end
