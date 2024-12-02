class PasswordResetsController < ApplicationController
  before_action :set_user_by_token, only: [:edit, :update]

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      PasswordMailer.with(user: user, token: user.generate_token_for(:password_reset)).password_reset.deliver_later
    end
    if params[:email].blank?
      return false
    else
      redirect_to root_url(format: :html), notice: "<i class='icon icon-mail mx-1'></i> We just sent you an email to reset your password."
    end
  end

  def edit
  end

  def update
    if @user.update(password_params)
      redirect_to root_url(format: :html), notice: "<i class='icon icon-check mx-1'></i> Password was reset successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_token_for(:password_reset, params[:token])
    redirect_to new_password_reset_url, alert: "<i class='icon icon-stop mx-1'></i> Invalid token, please try again." unless @user.present?
  end

  def password_params
    params.expect(user: [:password, :password_confirmation])
  end
end
