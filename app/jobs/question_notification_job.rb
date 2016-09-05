class QuestionNotificationJob < ActiveJob::Base
  queue_as :mailer

  def perform(question)
    question.subscriptions.each do |subscription|
      QuestionNotification.notify(subscription.user, question).deliver_later
    end
  end
end
