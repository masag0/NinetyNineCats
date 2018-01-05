class CatRentalRequestsController < ApplicationController
  before_action :require_valid_cat_request, only: [:approve, :deny]
  # before_action :require_logged_in,

  helper_method :valid_cat_request?

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.user_id = current_user.id
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  def require_valid_cat_request
    if !valid_cat_request?
      flash[:errors] = ["Not your cat!"]
      redirect_to cat_url(current_cat)
    end
  end

  def valid_cat_request?
    return false if current_user.nil?

    current_user.cats.each do |cat|
      return true if cat.id == params[:cat_id].to_i
    end
    false
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end



end
