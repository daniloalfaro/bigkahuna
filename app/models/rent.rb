# frozen_string_literal: true

class Rent < ApplicationRecord
  validates :return_date, presence: true
  validates :user_id, presence: true
  validates :movie_id, presence: true
  validates :quantity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :price_rental,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  belongs_to :movie
  belongs_to :user

  before_save :change_stock_rent

  def change_stock_rent
    if real_return_date.nil? && !return_date.nil?
      movie.stock_rental -= quantity
      movie.save
    elsif !real_return_date.nil? && !return_date.nil?
      movie.stock_rental += quantity
      movie.save
    end
  end

  def check_return_dates
    update(penalty: Movie::PENALTY) if real_return_date > return_date
  end
end
