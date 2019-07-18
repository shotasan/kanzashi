class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, index: true
      t.references :review, foreign_key: true, index: true
      t.string :content

      t.timestamps
    end
  end
end
