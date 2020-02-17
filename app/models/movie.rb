# frozen_string_literal: true

class Movie < ApplicationRecord
  audited
  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[name description],
                  using: { tsearch: { prefix: true } }

  scope :available,      -> { where(availability: true) }
  scope :unavailable,    -> { where(availability: false) }
  scope :order_by_name,  -> { order('name ASC') }
  scope :order_by_likes, lambda {
                           left_outer_joins(:likes)
                             .select('movies.*, COUNT(likes.*) AS likes_count')
                             .group('movies.id')
                             .reorder('COUNT(likes.id) DESC, name ASC')
                         }

  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :stock_sale,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }
  validates :stock_rental,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }
  validates :price_sale,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :price_rental,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :availability, presence: true

  has_many :likes, counter_cache: true
  has_many :buys
  has_many :rents

  has_one_attached :picture

  PENALTY = 15.50

  def check_stock(type, quantity = 1)
    return false unless availability

    if type == 'rental'
      stock_rental >= quantity
    elsif type == 'sale'
      stock_sale >= quantity
    else
      false
    end
  end

  def checkout(uid, quantity = 1)
    buys.new(price_sale: price_sale,
             user_id: uid,
             quantity: quantity).save
  end

  def lend(uid, return_days, quantity = 1)
    rents.new(price_rental: price_rental,
              user_id: uid,
              quantity: quantity,
              return_date: DateTime.now.end_of_day + return_days.days).save
  end
end
