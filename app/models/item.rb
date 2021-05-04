class Item < ApplicationRecord
  has_many :quote_products

  validates :name, :individual_cost, presence: true
end
