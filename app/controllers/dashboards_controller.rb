class DashboardsController < ApplicationController
  def index
    @assets = policy_scope(Asset.all)
    # asset_kind
<<<<<<< HEAD:app/controllers/dashboard_controller.rb
    asset_controller = AssetController.new
    @all_assets_hash = asset_controller.index_all_assets(current_user)
=======
    asset_controller = AssetsController.new
    @all_assets_hash = asset_controller.index_all_assets
>>>>>>> master:app/controllers/dashboards_controller.rb
    @total_value = asset_controller.calculate_total_value(@all_assets_hash)
    # price_points
    price_point_controller = PricePointsController.new
    @price_points = price_point_controller.index_pp(params[:query])
  end
end
