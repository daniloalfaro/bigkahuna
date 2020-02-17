class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.integer :stock_sale, default: 0
      t.integer :stock_rental, default: 0
      t.decimal :price_rental, precision: 5, scale: 2
      t.decimal :price_sale, precision: 5, scale: 2
      t.boolean :availability, default: true
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
