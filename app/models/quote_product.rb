class QuoteProduct < ApplicationRecord
  belongs_to :quote

  enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }  # FIXME: 1. poor naming, should be plural. 2. to be a separate model or STI.

  validates :product, presence: true # FIXME: amount is verified below. double up validation
  validates :amount, presence: true # FIXME: amount is verified below. double up validation
  validates :amount, inclusion: (1..9999)

  def cost
    tax_free_cost + tax_amount + import_duty_amount
  end

  def tax_free_cost
    amount * individual_cost
  end

  def individual_cost
    if face_mask? then 1
    elsif first_aid_kit? then 10
    else
      0.5
    end
  end

  def tax_amount
    if book? then tax_free_cost * 0.1
    else
      0
    end
  end

  def import_duty_amount
    if first_aid_kit? then 0
    else
      tax_free_cost * 0.05
    end
  end
end
