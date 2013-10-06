class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :name
      t.decimal :amount,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.string :description
      t.belongs_to :order
      t.belongs_to(:item, :polymorphic => true)
      t.timestamps
    end
    add_index :line_items, :order_id
    add_index :line_items, :item_id
    add_index :line_items, :item_type
  end
end
