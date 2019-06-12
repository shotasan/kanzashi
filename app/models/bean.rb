class Bean < ApplicationRecord
  has_many :targets, dependent: :destroy
end
