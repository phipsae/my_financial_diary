class DashboardsController < ApplicationController
  def index
    @assets = policy_scope(Asset.all)
    # asset_kind
    assets_controller = AssetsController.new
    @all_assets_hash = assets_controller.index_all_assets(current_user)
    @total_value = assets_controller.calculate_total_value(@all_assets_hash)
    # price_points
    price_point_controller = PricePointsController.new
    @price_points_query = price_point_controller.index_pp(params[:query], current_user)
    @price_points_count = price_point_controller.index_pp(params[:query], current_user).size
    if params[:more].present?
      @price_points = @price_points_query
    else
      @price_points = @price_points_query.limit(4)
    end
    # chart
    charts_controller = ChartsController.new
    if params[:period] == "3year"
      @line_chart_data = charts_controller.all_asset_hash_value_month(36, current_user)
      @performance = charts_controller.calculate_performance_all_asset_in_percent(36, current_user)
    elsif params[:period] == "1year"
      @line_chart_data = charts_controller.all_asset_hash_value_month(12, current_user)
      @performance = charts_controller.calculate_performance_all_asset_in_percent(12, current_user)
    else
      @line_chart_data = charts_controller.all_asset_hash_value(current_user)
      @performance = charts_controller.calculate_total_performance(current_user)
    end
  end
end
