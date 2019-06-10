class Review < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :rating, :bitter, :acidity, :rich, :sweet, :aroma, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 1_000 }
  validates :rating, :bitter, :acidity, :rich, :sweet, :aroma,
            presence: true,
            inclusion: { in: [*1..5] }
end
