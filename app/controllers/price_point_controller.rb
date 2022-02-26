class PricePointController < ApplicationController
  def index_pp
    @price_points = PricePoint.all.order(date: :desc) # user_id: current_user, DONT forget to add
    # if params[:query].present?
    #   @price_points = PricePoint.where(asset: asset)
    # end
  end
end
