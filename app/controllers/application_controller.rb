class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def authenticate_user!
    redirect_to root_path, alert: "You need to be logged in to do that. <i class='icon icon-stop'></i>" unless current_user.present?
  end

  def current_user
    Current.user ||= authenticate_from_session
  end

  def authenticate_from_session
    User.find_by(id: session[:user_id]) if session[:user_id].present?
  end

  def logged_in?
    current_user.present?
  end

  def login(user)
    Current.user = user
    reset_session
    session[:user_id] = user.id
  end

  def logout
    Current.user = nil
    reset_session
  end
end
