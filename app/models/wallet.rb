class Wallet < ActiveRecord::Base
 attr_accessible :balance
 has_many :deposits,:class_name => "Item", :as=>:itemable
 belongs_to :user

 def on_order_cancelled(item)
   #release_item
 end

 def on_order_success(item)
   item.delivered
 end

 def credit_wallet(amount_add)
   self.transaction do
     add_to_wallet(amount_add)
   end
 end

 def debit_wallet(amount_minus)
   self.transaction do
     raise Exception unless self.balance > amount_minus
     subtract_from_wallet(amount_minus)
   end
 end

 def deliver(item)
 end

 def name
   "Deposit"
 end

 private

 def add_to_wallet(amount)
   update_balance(amount)
 end

 def subtract_from_wallet(amount)
   add_to_wallet(-amount)
 end

 def update_balance(new_credit)
   new_score = self.balance += new_credit
   self.update_attribute(:balance, new_score)
 end

end
