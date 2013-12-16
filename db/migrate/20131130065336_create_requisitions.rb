class CreateRequisitions < ActiveRecord::Migration
  def change
    create_table :requisitions do |t|
      t.decimal :amount,     :precision => 10, :scale => 0, :default => 0, :null => false
      t.belongs_to :vault
      t.belongs_to :top_up
      t.string :state
      t.timestamps
    end
  end
end
