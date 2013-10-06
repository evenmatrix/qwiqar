class PhoneNumber < ActiveRecord::Base
  attr_accessible :carrier, :number
  belongs_to :user
end
