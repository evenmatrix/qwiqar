class Contact < ActiveRecord::Base
  attr_accessible :first_name, :last_name,:phone_number_attributes
  has_one :phone_number ,:dependent=>:destroy, :as=>:entity
  has_many :contact_top_ups
  accepts_nested_attributes_for :phone_number
  validates_presence_of  :phone_number,:first_name, :last_name
  has_attached_file :photo,:styles => {:icon=>"50x50#",:thumb => "200x297>", :croppable => '600x600>'}
  belongs_to :user
  def name
    [first_name, last_name].compact.join(" ")
  end

  searchkick autocomplete: ['first_name','last_name']



end
