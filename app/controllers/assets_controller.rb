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

    # display specific assets
    if params[:query].present?
      @assets = Asset.where(category: params[:query], user_id: current_user)
      @category = params[:query]
    end
  end

  def show
    authorize @asset
    @price_point = PricePoint.new(asset: @asset)
    coinmarketcap_api(params[:amount], params[:symbol]) if params[:amount].present? && params[:symbol].present?
    @category = set_asset.category
    @latest_price_point = get_last_price_point(@asset)
    @sorted_price_points = @asset.price_points.order(date: :desc, id: :desc)
    @categories_hash = create_categories_hash(current_user)
    @all_assets_hash = index_all_assets(current_user)
  end

  def update
  end

  def destroy
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
    @asset = Asset.new(asset_params)
    @asset.user = current_user
    authorize @asset
    if @asset.save
      redirect_to asset_url(@asset)
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
      # user_id: current_user, DONT forget to add
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
      category_hash[:"#{asset.sub_category}"] = { value: cents, date: date }
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
    url = "https://pro-api.coinmarketcap.com/v2/tools/price-conversion?amount=#{amount}&symbol=#{symbol}&CMC_PRO_API_KEY=#{ENV["COINMARKETCAP_API_KEY"]}"
    response = URI.open(url).read
    @data = JSON.parse(response)
    @value = @data["data"][0]["quote"]["USD"]["price"]
  end
end
