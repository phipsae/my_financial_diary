class Asset < ApplicationRecord
  belongs_to :user
  has_many :price_points, dependent: :destroy
  has_one :real_estate, dependent: :destroy

  accepts_nested_attributes_for :price_points

  # for create form real estate
  accepts_nested_attributes_for :real_estate

  enum category: {
    cash: 0,
    securities: 1,
    real_estate: 2,
    raw_materials: 3,
    crypto: 4,
    cars: 5,
    others: 6
  }

  SUB_CATEGORIES = {
    securities: { bonds: ["Bonds", "bonds"], shares: ["Shares", "shares"], fonds: ["Fonds", "fonds"] },
    raw_materials: { gold: ["Gold", "gold"], silver: ["Silver", "silver"], others: ["Others", "others"] },
    crypto: { btc: ["BTC", "btc"], eth: ["ETH", "eth"], usdt: ["Tether", "usdt"], bnb: ["BNB", "bnb"], usdc: ["USD Coin", "usdc"], luna: ["Terra", "luna"], xrp: ["XRP", "xrp"], ada: ["Cardano", "ada"], sol: ["Solana", "sol"], avax: ["Avalanche", "avax"], dot: ["Polkadot", "dot"],others: ["Others", "others"] }
  }

  validates :name, :category, :sub_category, presence: true
  # validates :sub_category, uniqueness: true
end
