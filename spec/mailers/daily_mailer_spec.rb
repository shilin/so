require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:today_question) { create(:question) }
    let!(:yesterday_question1) { create(:question, created_at: 1.day.ago) }
    let!(:yesterday_question2) { create(:question, created_at: 1.day.ago) }
    let(:mail) { DailyMailer.digest(user, [yesterday_question1, yesterday_question2]) }

    it 'includes in digest only questions from yesterday' do
      expect(mail.body.encoded).to match(yesterday_question1.title)
      expect(mail.body.encoded).to_not match(today_question.title)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq 'Questions digest with love'
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Here are new questions, appeared on our site')
    end
  end
end
