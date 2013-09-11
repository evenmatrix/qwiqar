class FeedbackMessage < ActiveRecord::Base
  attr_accessible :title, :message, :email, :name
  validates :message,:email, :presence => true
  #validates :email, :presence => true, :email => true

  after_create    :send_mail
  def send_mail
    FeedbackMailer.feedback_notice(self).deliver
  end


end
