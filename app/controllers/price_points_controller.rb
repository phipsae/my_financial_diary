class PricePointsController < ApplicationController
  before_action :set_asset, only: [ :create, :update ]

  def index_pp(params, user)
    if params.present?
      @price_points = PricePoint.where(asset: Asset.where(category: params, user_id: user)).order(date: :desc, id: :desc) # user_id: current_user, DONT forget to add
    else
      @price_points = PricePoint.where(asset: Asset.where(user_id: user)).order(date: :desc, id: :desc) # user_id: current_user, DONT forget to add
    end
  end

  def edit
    @price_point = set_price_point
    authorize @price_point
  end

  def update
    @category = Asset.find(params[:asset_id]).category
    authorize @price_point
    @price_point.update(price_point_params)
    if @category == "real_estate"
      @real_estate = Asset.find(params[:asset_id]).real_estate
      @real_estate.update(real_estate_params)
      @price_point.cents = calculate_real_estate_price(
        @real_estate.sqm,
        @real_estate.price_per_sqm,
        @real_estate.mortgage
      )
      @price_point.save
    end
    redirect_to asset_path(@price_point.asset)
  end

  def new
    @price_point = PricePoint.new
    @asset = Asset.new # for cash
    authorize @price_point
  end

  def create
    @price_point = PricePoint.new(price_point_params)
    @price_point.asset = @asset
    authorize @price_point
    if @asset.category == "real_estate"
      @real_estate = Asset.find(params[:asset_id]).real_estate
      @real_estate.update(real_estate_params)
      @price_point.cents = calculate_real_estate_price(
        @real_estate.sqm,
        @real_estate.price_per_sqm,
        @real_estate.mortgage
      )
      if @price_point.save
        if @real_estate.save
          redirect_to asset_path(@asset, anchor: "price-point-#{@price_point.id}")
        end
      end
    elsif @price_point.save
      redirect_to asset_path(@asset, anchor: "price-point-#{@price_point.id}") if @asset.category != "cash"
      redirect_to assets_path(query: "cash", anchor: "price-point-#{@price_point.id}") if @asset.category == "cash"
    else
      render :new
    end
  end

  def calculate_real_estate_price(sqm, price_per_sqm, mortgage)
    ((sqm * price_per_sqm) - mortgage) * 100
  end

  def destroy
    @price_point = set_price_point
    authorize @price_point
    @price_point.destroy
    redirect_back(fallback_location: dashboard_path)
  end






  private

  def set_price_point
    @price_point = PricePoint.find(params[:id])
  end

  def set_asset
    @asset = Asset.find(params[:asset_id])
  end

  def price_point_params
    params.require(:price_point).permit(:cents, :date, :text, :crypto_amount)
  end

  def real_estate_params
    params.require(:real_estates).permit(:sqm, :price_per_sqm, :mortgage)
  end

  # get_all_price_points_by_month

  # get_all_price_points_by_asset_and_month

  # get_all_inital_price_points
end
