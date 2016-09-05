class DailyDigestJob < ActiveJob::Base
  queue_as :mailer

  def perform
    yesterday_questions = Question.posted_yesterday

    User.find_each do |user|
      DailyMailer.digest(user, yesterday_questions.to_a).deliver_later
    end
  end
end
