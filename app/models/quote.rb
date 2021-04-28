# frozen_string_literal: true

class Quote < ApplicationRecord
  validates :email, presence: true

  has_many :products, class_name: 'QuoteProduct'

  def total_cost
    products.sum(&:cost)
  end
end
