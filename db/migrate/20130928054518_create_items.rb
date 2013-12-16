class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.decimal :amount,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.belongs_to :order
      t.belongs_to(:itemable, :polymorphic => true)
      t.timestamps
    end
    add_index :items, :order_id
    add_index :items, :itemable_id
    add_index :items, :itemable_type
  end
end
