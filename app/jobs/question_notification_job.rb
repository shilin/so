class QuestionNotificationJob < ActiveJob::Base
  queue_as :mailer

  def perform(question)
    pp question.subscriptions
    question.subscriptions.reverse_each do |subscription|
      QuestionNotification.notify(subscription.user, question).deliver_later
    end
  end
end
