class QuoteProduct < ApplicationRecord
  belongs_to :quote
  belongs_to :item

  validates :amount, presence: true, inclusion: (1..9999)

  def cost
    tax_free_cost + tax + import_duty
  end

  def tax_free_cost
    amount * individual_cost
  end

  delegate :individual_cost, to: :item

  def tax
    tax_free_cost * item.tax_rate
  end

  def import_duty
    tax_free_cost * item.import_duty_rate
  end
end
