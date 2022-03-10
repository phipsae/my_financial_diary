require "json"
require "open-uri"

class AssetsController < ApplicationController
  before_action :set_asset, only: [ :show, :edit, :update ]

  def index
    @assets = policy_scope(Asset)
    # render all assets
    @all_assets_hash = index_all_assets(current_user)
    @total_value = calculate_total_value(@all_assets_hash)

    # render specific comments
    price_point_controler = PricePointsController.new
    @price_points = price_point_controler.index_pp(params[:query], current_user)

    # cash
    create_cash_object(params[:query], current_user)

    # display specific assets
    if params[:query].present?
      @assets = Asset.where(category: params[:query], user_id: current_user)
      @category = params[:query]
    end
  end

  # def crypto_api
  #   @assets = policy_scope(Asset)
  #   authorize @assets
  #   coinmarketcap_api(params[:amount], params[:symbol]) if params[:amount].present? && params[:symbol].present?
  #   respond_to do |format|
  #     format.html { redirect_to asset_path(@asset.id) }
  #     format.json # Follow the classic Rails flow and look for a create.json view
  #   end
  # end

  # create cash object

  def create_cash_object(params, user )
    if params == "cash" && Asset.where(category: "cash").empty?
      @cash_asset = Asset.new
      @cash_asset.category = "cash"
      @cash_asset.sub_category = "cash"
      @cash_asset.name = "cash"
      @cash_asset.user = user
      @cash_asset.save
    elsif params == "cash"
      @price_point = PricePoint.new(asset: @cash_asset)
    end
  end

  def show
    authorize @asset
    if params[:pp_id].present?
      @price_point = PricePoint.find(params[:pp_id])
    else
      @price_point = PricePoint.new(asset: @asset)
      @result = coinmarketcap_api(params[:amount], params[:symbol]) if params[:amount].present? && params[:symbol].present?
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/form_asset_show_crypto_value.html', locals: { asset: @asset, price_point: @price_point } }
    end
    @category = set_asset.category
    @latest_price_point = get_last_price_point(@asset)
    @sorted_price_points = @asset.price_points.order(date: :desc, id: :desc)
    @categories_hash = create_categories_hash(current_user)
    @all_assets_hash = index_all_assets(current_user)
    @price_points = @asset.price_points.order(date: :desc, id: :desc)
  end

  def edit
    @asset = set_asset
    authorize @asset
    render "assets/new"
  end

  def update
    @asset = set_asset
    authorize @asset
    @asset.update(asset_params)
    redirect_to asset_path(@asset)
  end

  def destroy
    @asset = Asset.find(params[:id])
    authorize @asset
    @asset.destroy
    redirect_to assets_path(query: @asset.category)
  end

  def new
    if (category = params['category']).present?
      @asset = Asset.new(category: category)
    else
      @asset = Asset.new
    end
    authorize @asset
  end

  def create
    price_point_controller = PricePointsController.new
    @asset = Asset.new(asset_real_estate_params)
    @asset.user = current_user
    @asset.category = params[:category] if params[:category].present?
    authorize @asset

    if @asset.category == "real_estate"
      @real_estate = RealEstate.new(real_estates_params)
      @asset.sub_category = "flat"
      @price_point = PricePoint.new(price_points_params)
      @price_point.cents = price_point_controller.calculate_real_estate_price(
        @real_estate.sqm,
        @real_estate.price_per_sqm,
        @real_estate.mortgage
      )
      authorize @real_estate
      authorize @price_point
      if @asset.save
        @real_estate.asset = @asset
        @price_point.asset = @asset
        redirect_to "/assets?query=real_estate" if @real_estate.save && @price_point.save
      end
    elsif @asset.category != "real_estate"
      # redirect_to asset_url(@asset) if @asset.save
      redirect_to asset_path(@asset) if @asset.save
    else
      render :new
    end
  end

  def calculate_total_value_asset(categories_hash)
    @total_value = 0
    categories_hash.each do |_, value|
      @total_value += value unless value.nil?
    end
    @total_value
  end

  def calculate_total_value(assets_hash)
    @total_value = 0
    assets_hash.each do |_, value|
      @total_value += value unless value.nil?
    end
    @total_value
  end

  def index_all_assets(user)
    @assets_hash = {}
    categories_hash = create_categories_hash(user)
    categories_hash.each do |category, sub|
      asset_value = 0
      sub.each do |_, element|
        asset_value += element[:value]
      end
      @assets_hash[:"#{category}"] = asset_value
    end
    @assets_hash
  end

  def create_categories_hash(user)
    @categories_hash = {}
    Asset.categories.each_key do |category|
      @assets = Asset.where(user_id: user, category: category)
      category_hash = get_category_hash(@assets)
      @categories_hash[:"#{category}"] = category_hash
    end
    @categories_hash
  end

  def get_category_hash(assets)
    category_hash = {}
    assets.each do |asset|
      last_pp = get_last_price_point(asset)
      if last_pp.present?
        cents = last_pp.cents
        date = last_pp.date
      else
        cents = 0
        date = "2022-03-03"
      end
      category_hash[:"#{asset.name}"] = { value: cents, date: date } # sub_category changed to name !!!!
    end
    category_hash
  end

  def get_last_price_point(asset)
    price_points = PricePoint.where(asset: asset)
    last_pp = price_points.max_by do |element|
      element.date
    end
    last_pp
  end


  private

  def set_asset
    @asset = Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(:name, :category, :sub_category)
  end

  def coinmarketcap_api(amount, symbol)
    url = "https://pro-api.coinmarketcap.com/v2/tools/price-conversion?amount=#{amount}&symbol=#{symbol}&convert=EUR&CMC_PRO_API_KEY=#{ENV["COINMARKETCAP_API_KEY"]}"
    response = URI.open(url).read
    @data = JSON.parse(response)
    @value = @data["data"][0]["quote"]["EUR"]["price"]
  end

  def asset_real_estate_params
    params.require(:asset).permit(:name, :category, :sub_category)
  end

  def real_estates_params
    params.require(:real_estates).permit(:sqm, :price_per_sqm, :mortgage)
  end

  def price_points_params
    params.require(:price_points).permit(:cents, :text, :date)
  end
end
