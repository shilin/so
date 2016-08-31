require 'rails_helper'

RSpec.describe QuestionNotificationJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question) }
  let(:subscription1) { create(:subscription, user: users.first, subscribable: question) }
  let(:subscription2) { create(:subscription, user: users.second, subscribable: question) }

  it 'sends notification to users, subscribed to question' do
    [subscription1, subscription2].each do |subscription|
      expect(QuestionNotification).to receive(:notify).with(subscription.user, question).and_call_original
    end
    QuestionNotificationJob.perform_now(question)
  end
end
