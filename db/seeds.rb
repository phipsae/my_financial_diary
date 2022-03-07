# cleaning up seed
puts "cleaning up seed"
User.destroy_all
Article.destroy_all
puts "create new seed"

## User seed
puts "---------Users are created"
2.times do
  user = User.new(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    user_name: Faker::Internet.username,
    password: '123456',
    password_confirmation: '123456'
  )
  user.save

  puts "User created: #{user.id}"
end

## Asset_kind
categories = {
  securities: ["bonds", "shares", "fonds"],
  real_estate: ["Flat 1", "Flat 2", "House 1"],
  raw_materials: ["gold", "silver", "others"],
  crypto: ["BTC", "ETH", "others"],
  cars: ["VW", "BMW", "Porsche"],
  others: ["Whiskey", "Watches"]
}

puts "---------Assets are created"
User.all.each do |user|
  # All
  Asset.categories.each_key do |cat|
    categories[:"#{cat}"].each do |sub_cat|
      name = sub_cat
      category = cat
      sub_category = sub_cat
      asset = Asset.new(name: name, category: category, sub_category: sub_category)
      asset.user = user
      asset.save
    end
  end
end
puts "Assets created"

## Real Estate Seed
puts "---------Real estates are created"
assets_real_estates = []
Asset.all.each do |asset|
  if asset.category == "real_estate"
    assets_real_estates << asset
  end
end
p "assets_real_estates #{assets_real_estates.length} "

assets_real_estates.length.times do |f|
  address = "#{Faker::Address.country}, #{Faker::Address.city}, #{Faker::Address.street_address}"
  sqm = rand(50..200)
  price_per_sqm = rand(300_000..1_000_000)
  mortgage = rand(3_000_000..50_000_000)
  flat = assets_real_estates[f]
  real_estate = RealEstate.new(
    address: address,
    sqm: sqm,
    price_per_sqm: price_per_sqm,
    mortgage: mortgage,
  )
  real_estate.asset = flat
  real_estate.save
  puts "real estate created #{flat.name} with ID #{real_estate.id}"
end

## Price_points
puts "create price points"
Asset.all.each do |asset|
  date = Faker::Date.between(from: '2020-09-23', to: '2021-12-25')
  3.times do
    date += 1.month
    text = Faker::Lorem.sentence(word_count: 6)
    cents = rand(500_000..10_000_000)
    if asset.category == "real_estate"
      real_estate = RealEstate.where("asset_id = #{asset.id}").take
      price = Integer(real_estate.price_per_sqm * 1.1)
      mortgage = Integer(real_estate.mortgage * 0.99)
      real_estate.update(price_per_sqm: price, mortgage: mortgage)
      cents = (price * real_estate.sqm) - mortgage
    else
      cents = Integer(cents * 1.1)
    end
    price_point = PricePoint.new(cents: cents, date: date, text: text)
    price_point.asset = asset
    price_point.save
    puts price_point
  end
end

puts "Price points done"

## Arcticles Seed / Blog
puts "Artciles are created"

10.times do
  name = Faker::Lorem.sentence(word_count: 3)
  meta_title = Faker::Lorem.sentence(word_count: 4)
  meta_description = Faker::Lorem.sentence(word_count: 10)
  slug = Faker::Lorem.sentence(word_count: 1)
  content = Faker::Lorem.paragraph(sentence_count: 20)
  category = rand(0..6)
  author = Faker::Name.name_with_middle
  article = Article.new(
    name: name,
    meta_title: meta_title,
    meta_description: meta_description,
    slug: slug,
    content: content,
    category: category,
    author: author
  )
  article.save
  puts "article from #{article.author} saved"
end

puts "Seed done"
