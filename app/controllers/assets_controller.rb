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
    @category = set_asset.category
    @latest_price_point = get_last_price_point(@asset)
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
      # @asset.real_estates.build if category == "real_estate"
      # @asset.price_points.build if category == "real_estate"
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
      if @asset.save # && @real_estate.save && price_point.save
        @real_estate.asset = @asset
        @price_point.asset = @asset
        if @real_estate.save
          if @price_point.save
            redirect_to "/assets?query=real_estate"
          end
        end
      elsif @asset.category != "real_estate"
        redirect_to asset_url(@asset) if @asset.save
      else
        render :new
      end
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

  def asset_real_estate_params
    params.require(:asset).permit(:name, :category, :sub_category) # real_estates_attributes: [ :sqm, :price_per_sqm, :mortgage ], price_points_attributes: [ :cents, :text, :date ]
  end

  def real_estates_params
    params.require(:real_estates).permit(:sqm, :price_per_sqm, :mortgage)
  end

  def price_points_params
    params.require(:price_points).permit(:cents, :text, :date)
  end
end


# {"authenticity_token"=>"ikCVmdx+FdHlTdtlrVDV+5D9qUKslseG6ZSQO2PcAPQPG9G50g+8aJNmruaJBHiv9/KbQ1+tEXHQLH54Dq6TXw==",
#  "asset"=>{"name"=>"asdds", "category"=>"real_estate", "sub_category"=>"flat"},
#  "real_estates"=>{"sqm"=>"123", "price_per_sqm"=>"123", "mortgage"=>"123"},
#  "price_points"=>{"date"=>"2022-03-05", "text"=>"asdsa"},
#  "commit"=>"Add Asset"}
