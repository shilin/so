require 'rails_helper'

RSpec.describe QuestionNotification, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, user: user, subscribable: question) }
    let(:subscription2) { create(:subscription, user: user2, subscribable: question) }

    let(:mail) { QuestionNotification.notify(user, question) }

    it 'renders the headers' do
      expect(mail.subject).to eq 'New answer for the question'
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Here are new answers for the question')
    end
  end
end
