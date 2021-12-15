class RemoveProductColumnFromQuoteProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :quote_products, :product, :integer
  end
end
