class Like < ApplicationRecord
  has_one :user
  has_one :movie

  validates :user_id, uniqueness: { scope: :movie_id,
                                    message: 'Only one like per movie' }
  validates :user_id, presence: true
  validates :movie_id, presence: true
end
