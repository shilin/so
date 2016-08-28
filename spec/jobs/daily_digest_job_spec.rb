require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let(:today_questions) { create_list(:question, 2) }
  let(:yesterday_question1) { create(:question, created_at: 1.day.ago, user: users.first) }
  let(:yesterday_question2) { create(:question, created_at: 1.day.ago, user: users.first) }
  let!(:yesterday_questions) { [yesterday_question1, yesterday_question2] }

  it 'sends daily digest to all users' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user, yesterday_questions).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
