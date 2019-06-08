class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.boolean :original?, null: false, default: false
      t.string :title, null: false, default: ''
      t.text :content, null: false, default: ''
      t.string :image, null: false, default: ''
      t.date :drank_on, null: false
      t.integer :rating, null: false
      t.integer :bitter, null: false
      t.integer :acidity, null: false
      t.integer :rich, null: false
      t.integer :sweet, null: false
      t.integer :aroma, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
