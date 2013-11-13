class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :country_code
      t.timestamps
    end
    add_index :carriers, [:name,:country_code], :unique => true
  end
end
