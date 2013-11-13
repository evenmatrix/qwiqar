class PhoneNumber < ActiveRecord::Base
  attr_accessible :carrier_id, :number
  belongs_to :entity,:polymorphic => true
  belongs_to :carrier
  validates_presence_of  :carrier,:entity,:number
  validates_uniqueness_of :number
end
