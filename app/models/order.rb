class Order < ActiveRecord::Base
  attr_accessible :total_amount
  belongs_to :user
  has_many :line_items, :dependent => :destroy
end
