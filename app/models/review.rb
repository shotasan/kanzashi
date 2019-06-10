class Review < ApplicationRecord
  belongs_to :user

  validates :title, :content, :rating, :bitter, :acidity, :rich, :sweet, :aroma, presence: true
end
