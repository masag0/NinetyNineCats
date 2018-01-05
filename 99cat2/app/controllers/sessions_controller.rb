class SessionsController < ApplicationController


  # before_action :destroy, :require_logged_in
  # before_action :new, :require_logged_out

  def new #login page
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:users][:username],
                                    params[:users][:password])
    if @user.nil?
      flash.now[:errors] = ["Username or Password is incorrect"]
      render :new #login
    else
      login!
      redirect_to cats_url
    end
  end

  def destroy
    @current_user.reset_session_token! if @current_user
    session[:session_token] = nil
    @current_user = nil
    redirect_to cats_url
  end

end
