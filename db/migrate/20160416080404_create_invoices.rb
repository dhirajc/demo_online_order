class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :order, index: true, foreign_key: true
      t.decimal :amount
      t.string :invoice_type
      t.string :state
      t.boolean :active
      t.decimal :credited_amount

      t.timestamps null: false
    end
  end
end
