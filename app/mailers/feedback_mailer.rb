class FeedbackMailer < ActionMailer::Base
  def feedback_notice(feedback)
    @feedback = feedback
    mail :to => @feedback.email, :subject => "Thank You", :from => "noreply@qwiqar.com"
  end
end
