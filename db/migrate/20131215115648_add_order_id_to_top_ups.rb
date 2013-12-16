class AddOrderIdToTopUps < ActiveRecord::Migration
  def change
    add_column :top_ups,:top_genie_order_id, :string
    add_column :top_ups,:top_genie_order_status, :string
    add_column :top_ups,:top_genie_order_status_description, :string
    add_index :top_ups, :top_genie_order_id
  end
end
