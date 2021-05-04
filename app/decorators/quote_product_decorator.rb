class QuoteProductDecorator < ApplicationDecorator
  delegate_all

  def name
    return item.name.pluralize if amount > 1

    item.name
  end
end
