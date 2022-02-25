class AssetKindController < ApplicationController
  def index_asset_kind
    @categories_hash = {}
    AssetKind.categories.each_key do |category|
      # user_id: current_user, DONT forget to add
      @assets = Asset.where(asset_kind: AssetKind.where(category: category))
      # category_hash = {}
      category_hash = get_category_hash(@assets)
      @categories_hash[:"#{category}"] = category_hash
    end
    @categories_hash
  end

  def calculate_total_value
    @total_value = 0
    @categories_hash.each do |_, value|
      @total_value += value[:value] unless value[:value].nil?
    end
    @total_value
  end

  private

  def get_category_hash(assets)
    category_hash = {}
    assets.each do |asset|
      last_pp = get_last_price_point(asset)
      category_hash[:value] = last_pp.cents
      category_hash[:date] = last_pp.date
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
