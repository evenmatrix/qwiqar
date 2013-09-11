class CreateFeedbackMessages < ActiveRecord::Migration
  def change
    create_table :feedback_messages do |t|
      t.string :title
      t.string :name
      t.string :message
      t.string :email,              :null => false, :default => ""
      t.timestamps
    end
  end
end
