class UsersController < ApplicationController

  before_action :require_logged_in

  def new #sign up page
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private
  def user_params
    params.require(:users).permit(:username, :password)
  end
end
