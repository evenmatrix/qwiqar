class Wallet < ActiveRecord::Base
 attr_accessible :balance
 has_many :deposits,:dependent => :destroy
 belongs_to :user
end
