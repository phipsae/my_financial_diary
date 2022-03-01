class PricePointsController < ApplicationController
  before_action :set_asset, only: [ :create ]

  def index_pp(params)
    if params.present?
      @price_points = PricePoint.where(asset: Asset.where(category: params)) # user_id: current_user, DONT forget to add
    else
      @price_points = PricePoint.all.order(date: :desc) # user_id: current_user, DONT forget to add
    end
  end

  def show
  end

  def new
    @price_point = PricePoint.new
    authorize @price_point
  end

  def create
    @price_point = PricePoint.new(price_point_params)
    @price_point.asset = @asset
    authorize @price_point
    if @price_point.save
      redirect_to asset_path(@asset)
    else
      render :new
    end
  end

  private

  def set_price_point
    @price_point = PricePoint.find(params[:id])
  end

  def set_asset
    @asset = Asset.find(params[:asset_id])
  end

  def price_point_params
    params.require(:price_point).permit(:cents, :date, :text)
  end
end
