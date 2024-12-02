class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate_by(username: params[:account], password: params[:password]) || user = User.authenticate_by(email: params[:account], password: params[:password])
      login user
      flash[:notice] = "<i class='icon icon-check mx-1'></i> Logged in successfully."
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.action(:refresh, "") }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:notice] = "Logged out."
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.action(:refresh, "") }
    end
  end
end
