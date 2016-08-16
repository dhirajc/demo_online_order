class RemoveColumns < ActiveRecord::Migration
	def self.up
	  remove_column :orders, :status
	  remove_column :orders, :total
	  remove_column :orders, :vat
	  remove_column :orders, :delivery_cost
	  remove_column :orders, :transaction_id
	  remove_column :orders, :invoice
	  remove_column :orders, :pickup_time
	  remove_column :foods, :price
	  remove_column :foods, :status
	  remove_column :foods, :prep_time
	  remove_column :foods, :sales
	  remove_column :foods, :sale_price
	  remove_column :foods, :active
	  change_column :foods, :deleted_at, :datetime

	end
	def self.down
  		add_column :orders, :status, :string
  		add_column :orders, :total,  :integer
  		add_column :orders, :vat, :integer
  		add_column :orders, :delivery_cost, :integer
  		add_column :orders, :transaction_id, :string
  		add_column :orders, :invoice, :string
  		add_column :orders, :pickup_time, :integer
  		add_column :foods, :price, :float
  		add_column :foods, :status, :string
  		add_column :foods, :prep_time, :integer
  		add_column :foods, :sales, :text
  		add_column :foods, :sale_price, :float
  		add_column :foods, :active, :boolean
  		change_column :foods, :deleted_at, :string
	end
end
