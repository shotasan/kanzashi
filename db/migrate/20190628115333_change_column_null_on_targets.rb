class ChangeColumnNullOnTargets < ActiveRecord::Migration[5.2]
  def change
    change_column_null :targets, :roasted_on, true
  end
end
