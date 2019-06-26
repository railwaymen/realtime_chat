# frozen_string_literal: true

class SignInForm
  include ActiveModel::Model

  attr_accessor :email, :password
  attr_reader :user

  validates :email, :password, presence: true

  def save
    if valid?
      sign_in_user
    else
      false
    end
  end

  private

  def sign_in_user
    @user = User.find_by(email: email)
    if @user&.valid_password?(password)
      generate_tokens
    else
      errors.add(base: :email_or_password_invalid)
    end
  end

  def generate_tokens
    @user.generate_authentication_token
    @user.generate_refresh_token
    @user.save!
  end
end
