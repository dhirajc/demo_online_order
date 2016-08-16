class AddFieldsToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :product_keywords, :text
    add_column :foods, :available_at, :datetime
    add_column :foods, :deleted_at, :string
    add_column :foods, :meta_keywords, :string
    add_column :foods, :meta_description, :string
    add_column :foods, :featured, :boolean
  end
end
