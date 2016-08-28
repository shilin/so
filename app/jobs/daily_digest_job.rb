class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each do |user|
      DailyMailer.digest(user, Question.posted_yesterday.to_a).deliver_later
    end
  end
end
