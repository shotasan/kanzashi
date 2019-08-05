class Bean < ApplicationRecord
  has_many :targets, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { maximum: 30 }
  validates :country, length: { maximum: 30 }
  validates :plantation, length: { maximum: 30 }

  def beans_select_box
    "名称: #{self.name} 原産国: #{self.country} 農園: #{self.plantation}"
  end

  # bean削除時に関連するレビューを削除するメソッド
  def self.destroy_bean_and_related_reviews(bean)
    bean.transaction do
      review_ids = Target.where(bean_id: bean).pluck(:review_id)
      related_reviews = Review.where(id: review_ids)
      related_reviews.destroy_all
      bean.destroy!
    end
  rescue StandardError => e
    logger.debug(e)
    false
  end
end
