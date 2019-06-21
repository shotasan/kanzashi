class Target < ApplicationRecord
  belongs_to :review
  belongs_to :bean

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

end
