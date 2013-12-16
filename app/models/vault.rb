class Vault < ActiveRecord::Base
  attr_accessible :name, :balance
  has_many :requisitions
end
