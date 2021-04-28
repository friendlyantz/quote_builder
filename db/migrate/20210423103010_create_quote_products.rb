class CreateQuoteProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :quote_products do |t|
      t.belongs_to :quote, null: false, foreign_key: true
      t.integer :product
      t.integer :amount

      t.timestamps
    end
  end
end
