class AssetKindController < ApplicationController
  def index_asset_kind
    @asset_kind_hash = {}
    categories_hash = create_categories_hash
    asset_kind_value = 0
    categories_hash.each do |category, sub|
      sub.each do |_, element|
        asset_kind_value += element[:value]
      end
      @asset_kind_hash[:"#{category}"] = asset_kind_value
    end
    @asset_kind_hash
  end

  def calculate_total_value
    @total_value = 0
    @categories_hash.each do |_, value|
      @total_value += value[:value] unless value[:value].nil?
    end
    @total_value
  end

  def create_categories_hash
    @categories_hash = {}
    AssetKind.categories.each_key do |category|
      # user_id: current_user, DONT forget to add
      @assets = Asset.where(asset_kind: AssetKind.where(category: category))
      category_hash = get_category_hash(@assets)
      @categories_hash[:"#{category}"] = category_hash
    end
    @categories_hash
  end

  private

  def get_category_hash(assets)
    category_hash = {}
    sub_category_hash = {}
    assets.each do |asset|
      last_pp = get_last_price_point(asset)
      sub_category_hash[:value] = last_pp.cents
      sub_category_hash[:date] = last_pp.date
      category_hash[:"#{asset.asset_kind.sub_category}"] = sub_category_hash
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
