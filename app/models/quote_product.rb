class QuoteProduct < ApplicationRecord
  belongs_to :quote

  enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }

  validates :product, :amount, presence: true
  validates :amount, inclusion: (1..9999)

  def cost
    tax_free_cost + tax + import_duty
  end

  def tax_free_cost
    amount * individual_cost
  end

  def individual_cost
    if face_mask?
      1
    elsif first_aid_kit?
      10
    else
      0.5
    end
  end

  def tax
    if book?
      tax_free_cost * 0.1
    else
      0
    end
  end

  def import_duty
    if first_aid_kit?
      0
    else
      tax_free_cost * 0.05
    end
  end
end
