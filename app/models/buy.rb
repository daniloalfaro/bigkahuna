class Buy < ApplicationRecord
  has_one :user
  has_one :movie

  validates :user_id, presence: true
  validates :movie_id, presence: true
  validates :quantity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :price_sale,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  after_save :less_stock_sale

  def less_stock_sale
    movie.stock_sale -= quantity
    movie.save
  end
end
