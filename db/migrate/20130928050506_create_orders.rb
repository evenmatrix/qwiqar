class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_amount,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.belongs_to :user
      t.string :state
      t.timestamps
    end
    add_index :orders, :user_id
  end
end
