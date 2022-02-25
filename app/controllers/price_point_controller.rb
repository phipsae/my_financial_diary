class PricePointController < ApplicationController
  def index_pp
    @price_points = PricePoint.all.order(date: :desc) # user_id: current_user, DONT forget to add
  end
end
