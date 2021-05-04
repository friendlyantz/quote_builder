class QuoteProduct < ApplicationRecord
  include SyncQuoteProductItem

  belongs_to :quote
  belongs_to :item

  enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }  # FIXME: 1. poor naming, should be plural. 2. to be a separate model or column, using STI.

  validates :product, :amount, presence: true # FIXME: amount is verified below. double up validation
  validates :amount, inclusion: (1..9999)

  def cost
    tax_free_cost + tax + import_duty
  end

  def tax_free_cost
    amount * individual_cost
  end

  def individual_cost
    if face_mask? # FIXME: make it 1-liner? case logic can alos e used
      1
    elsif first_aid_kit?
      10
    else
      0.5
    end
  end

  # FIXME: can be confused with tax rate
  def tax
    if book? # FIXME: make it 1-liner? case logic can alos e used
      tax_free_cost * 0.1
    else
      0
    end
  end

  # FIXME: can be confused with import_duty rate
  def import_duty
    if first_aid_kit? # FIXME: make it 1-liner? case logic can alos e used
      0
    else
      tax_free_cost * 0.05
    end
  end
end
