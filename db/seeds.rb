## cleaning up seed

puts "cleaning up seed"
User.destroy_all
AssetKind.destroy_all
Article.destroy_all

puts "create new seed"

## User seed
puts "---------Users are created"
5.times do
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
puts "---------Asset_kinds are created"
# Cash
cash = AssetKind.new(
  sub_category: "Cash",
  category: 0
)
cash.save
puts "Cash created #{cash.id}"

# Securities - Bonds
bonds = AssetKind.new(
  sub_category: "Bonds",
  category: 1
)
bonds.save
puts "Bonds created #{bonds.id}"

# Securities - Shares
shares = AssetKind.new(
  sub_category: "Shares",
  category: 1
)
shares.save
puts "Bonds created #{shares.id}"

# Securities - Fonds
fonds = AssetKind.new(
  sub_category: "Fonds",
  category: 1
)
fonds.save
puts "Bonds created #{fonds.id}"

# AssetKind - Real estate
2.times do |f|
  real_estate_type = ["flat", "house"]
  real_estate = AssetKind.new(
    sub_category: real_estate_type[f],
    category: 2
  )
  real_estate.save
  puts "Real estate created #{real_estate.id}"
end

# Crypto
cryptos = ["BTC", "ETH", "ATOM", "DOT", "LUNA", "SOL", "ADA"]

cryptos.length.times do |f|
  crypto = AssetKind.new(
    sub_category: cryptos[f],
    category: 3
  )
  crypto.save
  puts " Crypto created #{crypto.sub_category}"
end

# Raw materials
raw_materials = ["Gold", "Bronze", "Silver", "Others"]

raw_materials.length.times do |f|
  raw_material = AssetKind.new(
    sub_category: raw_materials[f],
    category: 4
  )
  raw_material.save
  puts " Raw material created #{raw_material.sub_category}"
end

# Cars
cars = ["BMW", "VW", "Porsche", "Others"]

cars.length.times do |f|
  car = AssetKind.new(
    sub_category: cars[f],
    category: 5
  )
  car.save
  puts " Car created #{car.sub_category}"
end
# Others
2.times do
  other = AssetKind.new(
    sub_category: "Others",
    category: 6
  )
  other.save
  puts " Others created #{other.sub_category}"
end

## Asset seed
puts "---------Assets are created"
20.times do
  user_id = rand(User.first.id..User.last.id)
  asset_kind_id = rand(AssetKind.first.id..AssetKind.last.id)

  user = User.find(user_id)
  asset_kind = AssetKind.find(asset_kind_id)

  if asset_kind.category == "real_estate"
    name = Faker::Internet.username
  else
    name = asset_kind.category
  end
  asset = Asset.new(name: name)
  asset.user = user
  asset.asset_kind = asset_kind
  asset.save
  puts "asset created #{asset.name} with ID #{asset.id}"
end

## Real Estate Seed
puts "---------Real estates are created"
assets_real_estates = []
Asset.all.each do |asset|
  if asset.asset_kind.category == "real_estate"
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
    if asset.asset_kind.category == "real_estate"
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
