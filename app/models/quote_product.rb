class QuoteProduct < ApplicationRecord
  belongs_to :quote

  enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }  #FIXME 1. poor naming, should be plural. 2. to be a separate model or STI.


  validates :product, :amount, presence: true #FIXME amount is verified below. double up validation
  validates :amount, inclusion: (1..9999)

  def cost
    tax_free_cost + tax + import_duty
  end

  def tax_free_cost
    amount * individual_cost
  end

  def individual_cost
    if face_mask? #FIXME case logic can be used
      1
    elsif first_aid_kit?
      10
    else
      0.5
    end
  end

  def tax #FIXME can be confused with tax rate
    if book? #FIXME case logic can be used
      tax_free_cost * 0.1
    else
      0
    end
  end

  def import_duty #FIXME can be confused with import_duty rate
    if first_aid_kit? #FIXME case logic can be used
      0
    else
      tax_free_cost * 0.05
    end
  end
end
