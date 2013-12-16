class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.belongs_to :wallet
      t.timestamps
    end
    add_index :deposits, :wallet_id
  end
end
