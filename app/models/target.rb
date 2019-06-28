class Target < ApplicationRecord
  belongs_to :review
  belongs_to :bean

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :roasted, inclusion: { in: ApplicationController.helpers.roasted_select_box }
  validates :grind, inclusion: { in: ApplicationController.helpers.grind_select_box }
  validate :bean_registered_by_current_user?

  private

  def bean_registered_by_current_user?
    unless review.user.beans.any? {|bean| bean.id == bean_id}
      errors.messages[:bean_id] << 'は登録されていません'
    end
  end
end
