class AssetController < ApplicationController
  def index
    @assets = policy_scope(Asset)
    # render all assets
    @all_assets_hash = index_all_assets
    @total_value = calculate_total_value(@all_assets_hash)

    # render specific comments
    price_point_controler = PricePointController.new
    @price_points = price_point_controler.index_pp(params[:query])

    # display specific assets
    if params[:query].present?
      ####### DONT FORGET CURRENT_USER!!!!! #############
      @assets = Asset.where(category: params[:query], user_id: current_user)
      @category = params[:query]
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  def create
  end

  # methods for other controllers

  def calculate_total_value(assets_hash)
    @total_value = 0
    assets_hash.each do |_, value|
      @total_value += value unless value.nil?
    end
    @total_value
  end

  def index_all_assets
    @assets_hash = {}
    categories_hash = create_categories_hash
    asset_value = 0
    categories_hash.each do |category, sub|
      sub.each do |_, element|
        asset_value += element[:value]
      end
      @assets_hash[:"#{category}"] = asset_value
    end
    @assets_hash
  end

  def create_categories_hash
    @categories_hash = {}
    Asset.categories.each_key do |category|
      # user_id: current_user, DONT forget to add
      @assets = Asset.where(category: category, user_id: current_user)
      category_hash = get_category_hash(@assets)
      @categories_hash[:"#{category}"] = category_hash
    end
    @categories_hash
  end

  def get_category_hash(assets)
    category_hash = {}
    assets.each do |asset|
      last_pp = get_last_price_point(asset)
      category_hash[:"#{asset.sub_category}"] = { value: last_pp.cents, date: last_pp.date }
    end
    category_hash
  end

  def get_last_price_point(asset)
    price_points = PricePoint.where(asset: asset) # user_id: current_user, DONT forget to add
    last_pp = price_points.max_by do |element|
      element.date
    end
    last_pp
  end
end
