class Review < ApplicationRecord
  belongs_to :user
  has_many :targets, inverse_of: :review, dependent: :destroy
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true, limit: 3
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :targets, presence: true
  validates :rating, :bitter, :acidity, :rich, :sweet, :aroma, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 1_000 }
  validates :item, length: { maximum: 100 }
  validates :rating, :bitter, :acidity, :rich, :sweet, :aroma,
            presence: true,
            inclusion: { in: [*1..5] }
  validate :future_date_prohibited

  before_save :check_straight_or_blend

  scope :resent, -> { order(created_at: :desc) }

  paginates_per 10

  # レビューの一覧で豆の名前を表示するためのメソッド
  def target_beans
    targets = Target.where(review_id: self)
    beans = targets.map { |target| target.bean.name }
    beans.map { |bean| bean }
  end

  private

  def future_date_prohibited
    if drank_on.present? && drank_on > Date.today
      errors.add(:drank_on, 'に未来の日付は入力できません')
    end
  end

  # ストレートかブレンドを判定するメソッド
  def check_straight_or_blend
    self.blend = self.targets.length > 1
  end
end
