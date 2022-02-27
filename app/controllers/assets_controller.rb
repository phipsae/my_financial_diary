class AssetsController < ApplicationController
  before_action :set_asset, only: [ :show, :edit, :update ]

  def index
    @assets = policy_scope(Asset)
  end

  def show
    authorize @asset
    @price_point = PricePoint.new(asset: @asset)
    @latest_price_point = @asset.price_points.order("date desc").first
  end

  def update
  end

  def destroy
  end

  def create
  end

  private

  def set_asset
    @asset = Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(:name, :category, :sub_category)
  end
end
