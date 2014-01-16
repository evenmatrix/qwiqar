class Deposit < ActiveRecord::Base
  has_one :item, :as=>:itemable
  belongs_to :wallet

  def on_order_success(order)
    self.wallet.credit_wallet(order.item.amount)
  end

  def on_order_failed(order)

  end

  def on_order_cancelled(order)

  end



end
