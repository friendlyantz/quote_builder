# frozen_string_literal: true

class CreateQuotes < ActiveRecord::Migration[6.1]
  def change
    create_table :quotes do |t|
      t.string :title
      t.string :email

      t.timestamps
    end
  end
end
