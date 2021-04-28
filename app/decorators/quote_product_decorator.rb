class QuoteProductDecorator < ApplicationDecorator
  delegate_all

  def name
    product.humanize.pluralize
  end
end
