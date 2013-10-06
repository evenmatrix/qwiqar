class TopUp < ActiveRecord::Base
  attr_accessible :amount,:message
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  has_one :line_item, :as=>:item
end
