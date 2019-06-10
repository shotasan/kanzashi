class Review < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, :content, :rating, :bitter, :acidity, :rich, :sweet, :aroma, presence: true
end
