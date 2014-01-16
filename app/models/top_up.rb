include TopUpGenieHelper
class TopUp < ActiveRecord::Base
  attr_accessor :payment_processor_id
  attr_accessible :message ,:item_attributes, :payment_processor_id
  belongs_to :sender, :class_name => "User"
  has_one :item, :as=>:itemable
  validates_presence_of  :payment_processor_id
  has_one :requisition

  accepts_nested_attributes_for :item
  UNITS=[200,400,500,750]

  def on_top_up_delivered(top_up_genie_order)
    self.top_up_genie_status =top_up_genie_order[:orderstatus]
    self.item.delivered
      #send mail/sms
  end

  def on_top_failed
    self.item.failed
  end

  def on_order_success(order)
    top_up(self)
  end

  def on_order_cancelled(order)
    logger.info("Order : #{order.id} was cancelled")
    #release_item
  end

  def save_top_genie_order(top_up_genie_order)
    self.top_up_genie_id=top_up_genie_order[:id]
    self.top_up_genie_status =top_up_genie_order[:orderstatus]
    save
  end

  def deliver
    if self.top_up_genie_id.present?
      query_top_up_status(self)
    else
      top_up(self)
    end
  end

  def name
    "Top Up"
  end



end

class PhoneNumberTopUp  <  TopUp
  belongs_to :phone_number
end

class ContactTopUp < TopUp
  belongs_to :contact
end
