class CreateTopUps < ActiveRecord::Migration
  def change
    create_table :top_ups do |t|
      t.decimal :amount,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.string :message
      t.integer :sender_id
      t.integer :recipient_id
      t.timestamps
    end
    add_index :top_ups, :sender_id
    add_index :top_ups, :recipient_id
  end
end
