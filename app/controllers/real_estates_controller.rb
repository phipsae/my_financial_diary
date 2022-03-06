class RealEstatesController < ApplicationController

  def new
    @real_estate = RealEstate.new
    authorize @real_estate
  end

  def create
    raise
    @real_estate = RealEstate.new(real_estate_params)
    @real_estate.asset = @asset
    authorize @price_point
    if @real_estate.save
      redirect_to asset_path(@asset)
    else
      render :new
    end
  end
end
