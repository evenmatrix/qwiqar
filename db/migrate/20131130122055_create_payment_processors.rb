class CreatePaymentProcessors < ActiveRecord::Migration
  def change
    create_table :payment_processors do |t|
      t.string :name
      t.string :gateway_interface
      t.text :description
      t.timestamps
    end
  end
end
