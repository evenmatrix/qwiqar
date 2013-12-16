class Wallet < ActiveRecord::Base
 attr_accessible :balance
 has_many :deposits,:class_name => "Item", :as=>:itemable
 belongs_to :user

 def on_order_cancelled(deposit)
   logger.info("Depost : #{deposit.id} was cancelled")
   #release_item
 end
end
