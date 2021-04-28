class QuoteDecorator < ApplicationDecorator
  delegate_all

  def products
    object.products.decorate
  end
end
