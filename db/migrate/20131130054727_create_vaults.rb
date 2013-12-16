class CreateVaults < ActiveRecord::Migration
  def change
    create_table :vaults do |t|
      t.string :name
      t.decimal :balance,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.timestamps
    end
  end
end
