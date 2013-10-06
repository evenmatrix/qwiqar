class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.decimal :amount,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.belongs_to :wallet
      t.timestamps
    end
    add_index :deposits, :wallet_id
  end
end
