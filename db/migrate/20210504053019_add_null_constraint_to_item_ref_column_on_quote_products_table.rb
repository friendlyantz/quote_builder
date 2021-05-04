class AddNullConstraintToItemRefColumnOnQuoteProductsTable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :quote_products, :item_id, false
  end
end
