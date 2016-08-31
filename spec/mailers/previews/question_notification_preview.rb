# Preview all emails at http://localhost:3000/rails/mailers/question_notification
class QuestionNotificationPreview < ActionMailer::Preview
  def notify
    QuestionNotification.notify(User.first, Question.first)
  end
end
