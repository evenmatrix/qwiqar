class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.belongs_to :user
      t.decimal :balance,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.timestamps
    end
    add_index :wallets, :user_id
  end
end
