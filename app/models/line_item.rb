class LineItem < ActiveRecord::Base
  attr_accessible :amount,:description,:name
  belongs_to :item,:polymorphic=>true
  belongs_to :order
end
