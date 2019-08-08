class RenameOriginalColumnToReviews < ActiveRecord::Migration[5.2]
  def change
    rename_column :reviews, :original?, :blend
  end
end
