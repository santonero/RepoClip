class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update(password_params)
      redirect_to root_url(format: :html), notice: "<i class='icon icon-check mx-1'></i> Password was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
  end
end
