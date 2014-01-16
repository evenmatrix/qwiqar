class Carrier < ActiveRecord::Base
  attr_accessible :name, :country_code
  has_many :phone_numbers
end
