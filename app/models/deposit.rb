class Deposit < ActiveRecord::Base
  attr_accessible :amount
  has_one :line_item, :as=>:item
  belongs_to :wallet
end
