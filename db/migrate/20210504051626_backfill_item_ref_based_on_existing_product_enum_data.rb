class BackfillItemRefBasedOnExistingProductEnumData < ActiveRecord::Migration[6.1]
  # Disables the standard Rails transaction that is wrapped around each
  # migration. For this migration we're pretty safe in that we're updating in
  # batches using an update_all statement.
  disable_ddl_transaction!

  # We are re-implementing this class here for a good reason! Eventually
  # QuoteProduct's product will be completely removed from the application meaning that
  # if we just used QuoteProduct.product in the below code it wouldn't work. This
  # situation would only occur for new development environment setup's of the
  # application. It is a best practice to keep your migrations as reversible as possible.
  class QuoteProduct < ApplicationRecord
    enum product: { book: 1, face_mask: 2, first_aid_kit: 3 }
  end

  def up
    QuoteProduct.products.each_key do |product|
      update_product(product)
    end
  end

  def down
    QuoteProduct.products.each_key do |product|
      nullify_product(product)
    end
  end

  private

  def update_product(product)
    item = Item.find_by(name: product.to_s.humanize)

    QuoteProduct.send(product.to_sym).where(item_id: nil).in_batches do |product_batch|
      product_batch.update_all(item_id: item.id)
    end
  end

  def nullify_product(product)
    QuoteProduct.send(product.to_sym).where.not(item_id: nil).in_batches do |product_batch|
      product_batch.update_all(item_id: nil)
    end
  end
end
