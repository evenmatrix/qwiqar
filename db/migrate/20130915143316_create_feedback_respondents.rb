class CreateFeedbackRespondents < ActiveRecord::Migration
  def change
    create_table :feedback_respondents do |t|

      t.timestamps
    end
  end
end
