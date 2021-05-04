class AddItemRefToQuoteProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :quote_products, :item, foreign_key: true #  null: false removed to avoid conflict with existing entries that still use 'product' enum and has no item_id reference
  end
end
