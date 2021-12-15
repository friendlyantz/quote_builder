class Item < ApplicationRecord
  has_many :quote_products, dependent: :destroy

  validates :name, :individual_cost, presence: true
end
