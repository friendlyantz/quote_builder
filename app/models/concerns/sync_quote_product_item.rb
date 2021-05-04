# This should be removed once QuoteProduct.product is not longer necessary
module SyncQuoteProductItem
  extend ActiveSupport::Concern

  included do
    before_validation :sync_product_item
  end

  def sync_product_item
    self.item = Item.find_by(name: product.to_s.humanize) unless product.nil?
  end
end
