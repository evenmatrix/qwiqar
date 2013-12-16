class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :payment_processor
      t.string :state
      t.integer :transaction_id
      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :payment_processor_id
    add_index :orders, :transaction_id,:unique => :true
  end
end
