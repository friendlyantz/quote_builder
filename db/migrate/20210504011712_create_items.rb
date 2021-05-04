class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.float :individual_cost, null: false
      t.float :tax_rate, default: 0.0
      t.float :import_duty_rate, default: 0.0

      t.timestamps
    end
  end
end
