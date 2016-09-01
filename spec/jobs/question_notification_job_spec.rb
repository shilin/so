require 'rails_helper'

RSpec.describe QuestionNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:subscription1) { create(:subscription, subscribable: question) }
  let!(:subscription2) { create(:subscription, subscribable: question) }

  it 'sends notification to users, subscribed to question' do
    question.subscriptions.each do |sub|
      expect(QuestionNotification).to receive(:notify).with(sub.user, question).and_call_original
    end
    QuestionNotificationJob.perform_now(question)
  end
end
