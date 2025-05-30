class User < ApplicationRecord
  has_secure_password
  PASSWORD_FORMAT = /
  (?=.*\d)
  (?=.*[a-z])
  (?=.*[A-Z])
  (?=.*[[:^alnum:]])
  /x

  validates :username, presence: true, uniqueness: { allow_blank: true }, length: { maximum: 18 }
  validates :password, length: { minimum: 8 }, format: { with: PASSWORD_FORMAT, message: "must include at least one lowercase letter, one uppercase letter, one digit, and one special character" }, allow_nil: true
  validates :password, :password_confirmation, presence: true, on: :password_update
  validates :email, presence: true, uniqueness: { allow_blank: true }, length: { maximum: 42 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid adress" }
  normalizes :email, with: -> email { email.strip.downcase }
  normalizes :username, with: -> username { username.strip }

  generates_token_for :password_reset, expires_in: 10.minutes do
    password_salt&.last(10)
  end
end
