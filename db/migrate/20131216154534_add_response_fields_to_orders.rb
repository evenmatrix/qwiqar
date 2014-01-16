class AddResponseFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders,:response_code,:string
    add_column :orders,:response_description,:string
    add_column :orders,:payment_method,:string
  end
end
