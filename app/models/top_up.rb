class TopUp < ActiveRecord::Base
  attr_accessor :payment_processor_id
  attr_accessible :message ,:item_attributes, :payment_processor_id
  belongs_to :sender, :class_name => "User"
  has_one :item, :as=>:itemable
  validates_presence_of  :payment_processor_id
  has_one :requisition

  accepts_nested_attributes_for :item
  UNITS=[200,400,500,750]
  #check if requisition exist
    #yes check if requisition has been cleared
        #yes notify requisition cleared
    #no
        #clear requisition
  #no
     #create requisition and clear

  def deliver(order)

  end


  #we are cleared to proceed with delivery
  #attempt deliver a couple of times if it succeeds
  #set delivery state to true
  #if deliver fails deposit the requisition back to vault and wait for trigger
  def on_requisition_cleared(requisition)

  end

  def save_top_genie_order(order)
    self.top_up_genie_order_id=top_up_genie_order[:id]
    save
  end
  #desired target state indicating successful top_up  delivered=true
  def on_delivered(top_up_genie_order)
      self.top_up_genie_order_status =top_up_genie_order[:orderstatus]
      self.top_up_genie_order_description=top_up_genie_order[:description]
      self.delivered=true
      self.save
  end

  def on_deliveryError(top_up_genie_order)

  end

  def on_order_cancelled(order)
    logger.info("Order : #{order.id} was cancelled")
    #release_item
  end

  private

  def do_deliver

  end

end

class PhoneNumberTopUp  <  TopUp
  belongs_to :phone_number
end

class ContactTopUp < TopUp
  belongs_to :contact
end
