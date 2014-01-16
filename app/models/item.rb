class Item < ActiveRecord::Base
  attr_accessible :amount
  belongs_to :itemable,:polymorphic=>true
  belongs_to :order
  validates  :amount, presence:true
  validates :amount, numericality:true

  scope :delivered_top_ups, -> {with_state(:delivered)}
  scope :pending_delivery, ->    {with_state(:pending)}
  scope :failed_top_ups, ->    {with_state(:failed)}

  state_machine initial: :pending    do
    after_transition :pending => :failed, :do => :on_top_failed
    after_transition :pending => :delivered, :do => :on_top_up_delivered


    event :delivered do
      transition :pending => :delivered
    end

    event :fail do
      transition :pending => :failed
    end

  end

  def delivered?
    self.state == "delivered"
  end

  def failed?
    self.state == "failed"
  end

  def on_order_cancelled(order)
    self.itemable.on_order_cancelled(self)
    #release_item
  end

  def on_order_success(order)
    self.itemable.on_order_success(self)
  end

  def deliver(order)
    self.itemable.deliver
  end

end
