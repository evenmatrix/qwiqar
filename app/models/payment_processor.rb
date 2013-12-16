class PaymentProcessor < ActiveRecord::Base
  attr_accessible :name,:gateway_interface
end
