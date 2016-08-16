class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.string :description
      t.float :price
      t.string :status
      t.integer :category_id
      t.integer :prep_time
      t.text :sales

      t.timestamps null: false
    end
  end
end
