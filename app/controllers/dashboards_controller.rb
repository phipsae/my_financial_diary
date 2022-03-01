class DashboardsController < ApplicationController
  def index
    @assets = policy_scope(Asset.all)
    # asset_kind
    asset_controller = AssetsController.new
    @all_assets_hash = asset_controller.index_all_assets
    @total_value = asset_controller.calculate_total_value(@all_assets_hash)
    # price_points
    price_point_controller = PricePointsController.new
    @price_points = price_point_controller.index_pp(params[:query])
  end
end
