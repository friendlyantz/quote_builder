class QuoteProduct < ApplicationRecord
  include SyncQuoteProductItem

  belongs_to :quote
  belongs_to :item

  enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }  # FIXME: 1. poor naming, should be plural. 2. to be a separate model or column, using STI.

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
