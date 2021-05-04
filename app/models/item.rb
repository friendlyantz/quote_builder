class Item < ApplicationRecord
  validates :name, :individual_cost, presence: true
end
