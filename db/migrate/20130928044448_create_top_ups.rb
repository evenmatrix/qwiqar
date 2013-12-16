class CreateTopUps < ActiveRecord::Migration
  def change
    create_table :top_ups do |t|
      t.string :message
      t.integer :sender_id
      t.integer :receiver_id
      t.belongs_to :phone_number
      t.belongs_to :contact
      t.boolean :delivered
      t.string :type
      t.timestamps
    end
    add_index :top_ups, :sender_id
    add_index :top_ups, :receiver_id
    add_index :top_ups, :phone_number_id
    add_index :top_ups, :contact_id
  end
end
