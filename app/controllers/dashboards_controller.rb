class DashboardsController < ApplicationController
  def index
    @assets = policy_scope(Asset.all)
    # asset_kind
    assets_controller = AssetsController.new
    @all_assets_hash = assets_controller.index_all_assets(current_user)
    @total_value = assets_controller.calculate_total_value(@all_assets_hash)
    # price_points
    price_point_controller = PricePointsController.new
    @price_points = price_point_controller.index_pp(params[:query], current_user)

    #chart
    charts_controller = ChartsController.new
    @line_chart_data = charts_controller.all_asset_hash_value(current_user)
  end
end
