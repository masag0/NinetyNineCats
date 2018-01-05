class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    # fail
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login!
    session[:session_token] = @user.reset_session_token!
  end

  def logged_in?
    return true if current_user
    false
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def require_logged_out
    redirect_to cats_url if logged_in?
  end

  def require_valid_cat #if current user is owner of cat in params
    redirect_to cats_url if !valid_cat?
  end

  def valid_cat?
    return false if current_user.nil?
    current_user.cats.each do |cat|
      return true if cat.id == params[:id].to_i
    end
    false
  end


end
