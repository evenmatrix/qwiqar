class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.belongs_to :user
      t.belongs_to :contact_group
      t.timestamps
    end
    add_index :contacts, :phone_number, :unique => true
    add_index :contacts, :user_id
  end
end
