class DashboardsController < ApplicationController
  def index
    @assets = policy_scope(Asset.all)
    # asset_kind
    asset_kind_controller = AssetKindController.new
    @categories_hash = asset_kind_controller.index_asset_kind
    @total_value = asset_kind_controller.calculate_total_value

    # price_points
    price_point_controller = PricePointController.new
    @price_points = price_point_controller.index_pp
  end
end
