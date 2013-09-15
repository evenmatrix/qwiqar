class FeedbackMailer < ActionMailer::Base
  RESPONDENTS=["evenmatrix@gmail.com"]
  def feedback_notice(feedback)
    @feedback = feedback
    mail :to => @feedback.email, :subject => "Thank You", :from => "noreply@qwiqar.com"
  end

  def notify_respondents(feedback)
    @feedback = feedback
    mail :to => RESPONDENTS, :subject => "New Feedback Received", :from => "noreply@qwiqar.com"
  end
end
