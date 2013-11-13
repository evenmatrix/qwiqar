class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.belongs_to :carrier
      t.string :number
      t.belongs_to(:entity, :polymorphic => true)
      t.timestamps
    end
    add_index :phone_numbers, :number, :unique => true
    add_index :phone_numbers, :entity_id
  end
end
