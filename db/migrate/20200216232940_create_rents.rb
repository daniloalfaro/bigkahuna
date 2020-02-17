class CreateRents < ActiveRecord::Migration[6.0]
  def change
    create_table :rents do |t|
      t.integer :user_id, null: false
      t.integer :movie_id, null: false
      t.integer :quantity, null: false
      t.decimal :price_rental, precision: 5, scale: 2, default: 0
      t.datetime :return_date, null: false
      t.datetime :real_return_date
      t.decimal :penalty, precision: 5, scale: 2, default: 0
      t.timestamps
    end
  end
end
