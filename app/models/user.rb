class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me,:first_name,:last_name
  validates :first_name,:last_name, :presence => true

  has_attached_file :avatar,:styles => {:icon=>"50x50#",:thumb => "200x297>", :croppable => '600x600>'}

  has_many :sent_top_ups,:foreign_key => "sender_id",:class_name => "TopUp"
  has_many :received_top_ups,:foreign_key => "recipient_id",:class_name => "TopUp"
  has_many :contacts ,:dependent=>:destroy
  has_one :phone_number ,:dependent=>:destroy, :as=>:entity
  has_one :wallet ,:dependent=>:destroy
  has_many :orders  ,:dependent=>:destroy

  def user_name
    "#{self.first_name}##{self.last_name}#{self.id}"
  end

  after_create :create_wallet

  def create_wallet
     self.wallet= Wallet.new
     save
  end
end
