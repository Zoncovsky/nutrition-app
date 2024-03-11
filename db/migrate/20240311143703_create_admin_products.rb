class CreateAdminProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 12, scale: 2, default: 0
      t.references :category, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
