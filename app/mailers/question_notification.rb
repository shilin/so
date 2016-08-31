class QuestionNotification < ApplicationMailer
  def notify(user, question)
    @question = question
    mail to: user.email, subject: 'New answer for the question'
  end
end
