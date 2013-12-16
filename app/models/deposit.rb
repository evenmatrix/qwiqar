class Deposit < ActiveRecord::Base
  has_one :item, :as=>:itemable
  belongs_to :wallet
  accepts_nested_attributes_for :item
end
