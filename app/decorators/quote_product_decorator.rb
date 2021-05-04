class QuoteProductDecorator < ApplicationDecorator
  delegate_all

  def name
    item.name.pluralize
  end
end
