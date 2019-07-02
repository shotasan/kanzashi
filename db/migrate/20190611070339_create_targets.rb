class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :targets do |t|
      t.references :review, foreign_key: true
      t.references :bean, foreign_key: true
      t.string :roasted, null: false, default: ''
      t.date :roasted_on, null: false
      t.string :grind, null: false, default: ''
      t.integer :amount, null: false, default: 0

      t.timestamps
    end
  end
end
