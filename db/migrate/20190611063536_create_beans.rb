class CreateBeans < ActiveRecord::Migration[5.2]
  def change
    create_table :beans do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :country, null: false, default: ''
      t.string :plantation, null: false, default: ''

      t.timestamps
    end
  end
end
