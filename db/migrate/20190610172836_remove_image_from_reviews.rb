class RemoveImageFromReviews < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :image, :string
  end
end
