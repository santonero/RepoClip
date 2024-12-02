class RegistrationsController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      login @user
      redirect_to root_url(format: :html), notice: "<i class='icon icon-check mx-1'></i> Account successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.expect(user: [:username, :email, :password, :password_confirmation])
  end
end
