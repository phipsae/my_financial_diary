class ChartsController < ApplicationController
  # calculate performance
  def calculate_performance_all_asset_in_percent(months, user)
    asset_hash = all_asset_hash_value(user)
    month_keys = asset_hash.keys.reverse
    performance = 0
    if months <= month_keys.length # month_year_array(PricePoint.all.order(date: :asc).first.date).reverse
      month_key_now = month_keys.first
      month_key_before = month_keys[months - 1]
      performance = (((asset_hash[month_key_now].to_f / asset_hash[month_key_before]) - 1) * 100).round
    else
      performance = calculate_total_performance(user)
    end
    performance.nil? ? 0 : performance
  end

  def calculate_total_performance(user)
    asset_hash = all_asset_hash_value(user)
    month_keys = asset_hash.keys.reverse # month_year_array(PricePoint.all.order(date: :asc).first.date).reverse
    month_key_now = month_keys.first
    month_key_before = month_keys.last
    asset_hash[month_key_before].nil? ? 0 : (((asset_hash[month_key_now].to_f / asset_hash[month_key_before]) - 1) * 100).round
  end

  # Calculate hashes
  def all_asset_hash_value_month(months, user)
    asset_hash = all_asset_hash_value(user)
    month_keys = asset_hash.keys
    hash = all_asset_hash_value(user)
    hash.slice(*month_keys.last(months)) if months < month_keys.length
  end

  def all_asset_hash_value(user)
    asset_array = all_cat_hash_value_date(user)
    hash = asset_array.reduce({}) do |sums, location|
      sums.merge(location) { |_, a, b| a + b }
    end
    hash
  end

  def all_cat_hash_value_date(user)
    array = []
    Asset::CATEGORIES.each do |cat|
      array << cat_hash_date_value(cat, user)
    end
    array
  end

  def cat_hash_date_value(cat, user)
    cat_array = category_hash_array(cat, user)
    hash = cat_array.reduce({}) do |sums, location|
      sums.merge(location) { |_, a, b| a + b }
    end
    hash
  end

  def category_hash_array(cat, user)
    array = []
    subs = Asset.where(category: cat, user: user)
    subs.each do |sub|
      array << sub_cat_hash_with_all_dates_cents(sub.sub_category, user)
    end
    array
  end

  def sub_cat_hash_with_all_dates_cents(sub_cat, user)
    first_pp_date = first_pp_all(user).date
    month_year_array = month_year_array(first_pp_date)
    sub_cat_hash = sub_cat_hash(sub_cat, user)
    hash = {}
    latest_value = 0
    month_year_array.each do |date|
      sub_cat_hash.each do |sub_cat|
        latest_value = sub_cat[1] / 100 if date == sub_cat[0]
        hash[date] = latest_value
      end
    end
    hash
  end

  def sub_cat_hash(sub_cat, user)
    all_pp = all_pp(sub_cat, user)
    grouped = all_pp.all.group_by { |m| m.date.beginning_of_month }
    hash = {}
    grouped.each do |date|
      date_date = date[0]
      max_num = 0
      date[1].each { |n| max_num = n.cents if n.cents > max_num }
      hash[date_date] = max_num
    end
    hash
  end

  def all_pp(sub_cat, user)
    PricePoint.where(asset: Asset.where(sub_category: sub_cat, user: user)).order(date: :asc)
  end

  def first_pp_all(user)
    PricePoint.where(asset: Asset.where(user: user)).order(date: :asc).first
  end

  # get first pp for asset
  def first_pp(sub_cat)
    PricePoint.where(asset: Asset.where(sub_category: sub_cat, user: current_user)).order(date: :asc).first
  end

  # create month-year-array from first pp
  def month_year_array(start_date)
    date_from = start_date # PricePoint.all.order(date: :asc).first.date
    date_to = Time.now
    date_range = date_from..date_to

    date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
    # date_months.map {|d| (d.strftime "%d/%m/%Y") }
  end
end
