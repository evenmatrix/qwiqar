class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :carrier
      t.string :number
      t.belongs_to :user
      t.timestamps
    end
    add_index :phone_numbers, :number, :unique => true
    add_index :phone_numbers, :user_id
  end
end
