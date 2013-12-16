class PhoneNumber < ActiveRecord::Base
  attr_accessible :carrier_id, :number
  belongs_to :entity,:polymorphic => true
  belongs_to :carrier
  has_many :phone_number_top_ups
  validates_presence_of  :carrier_id,:number
  validates_uniqueness_of :number

  def self.uniq(carrier_id,number)
    begin
        where("carrier_id = ? AND number = ?",carrier_id,number ).first
    rescue Exception=>e
        nil
    end
  end


end
