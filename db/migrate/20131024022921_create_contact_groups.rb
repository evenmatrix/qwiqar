class CreateContactGroups < ActiveRecord::Migration
  def change
    create_table :contact_groups do |t|
       t.belongs_to :user
       t.string :name
       t.text :about
      t.timestamps
    end
    add_index :contact_groups, :user_id
  end
end
