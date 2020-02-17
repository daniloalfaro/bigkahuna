class CreateBuys < ActiveRecord::Migration[6.0]
  def change
    create_table :buys do |t|
      t.integer :user_id, null: false
      t.integer :movie_id, null: false
      t.integer :quantity, null: false
      t.decimal :price_sale, precision: 5, scale: 2, default: 0
      t.timestamps
    end
  end
end
