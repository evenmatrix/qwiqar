class FeedbackResponseMailer < ActionMailer::Base
  def notify_respondents(feedback)
    @feedback = feedback
    mail :to => @feedback.email, :subject => "New Feedback", :from => "noreply@qwiqar.com"
  end
end
