class Item < ActiveRecord::Base
  attr_accessible :amount
  belongs_to :itemable,:polymorphic=>true
  belongs_to :order
  validates  :amount, presence:true
  validates :amount, numericality:true

  def on_order_cancelled(order)
    self.itemable.on_order_cancelled(self)
    #release_item
  end
end
