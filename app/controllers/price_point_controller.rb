class PricePointController < ApplicationController
  def index_pp(params)
    if params.present?
      @price_points = PricePoint.where(asset: Asset.where(category: params)) # user_id: current_user, DONT forget to add
    else
      @price_points = PricePoint.all.order(date: :desc) # user_id: current_user, DONT forget to add
    end
  end
end
