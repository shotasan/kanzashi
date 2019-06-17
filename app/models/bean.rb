class Bean < ApplicationRecord
  has_many :targets, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :country, length: { maximum: 30 }
  validates :plantation, length: { maximum: 30 }
end
