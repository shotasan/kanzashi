class Bean < ApplicationRecord
  has_many :targets, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { maximum: 30 }
  validates :country, length: { maximum: 30 }
  validates :plantation, length: { maximum: 30 }

  def beans_select_box
    "名称: #{self.name} 原産国: #{self.country} 農園: #{self.plantation}"
  end
end
