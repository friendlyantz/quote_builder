# frozen_string_literal: true

class Quote < ApplicationRecord
  validates :email, presence: true #FIXME custom message can be added

  has_many :products, class_name: 'QuoteProduct' #FIXME poor naming. QuoteProducts table has enum 'product' Ideally product to be moved into a separate table

  def total_cost
    products.sum(&:cost)
  end
end
