class AddItemToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :item, :string, default: ''
  end
end
