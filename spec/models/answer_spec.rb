require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it "ensures all question's answers made unbest" do
    user = create(:user)
    question = create(:question, user: user)
    answer1 = create(:answer, question: question, user: user, best: true)
    answer2 = create(:answer, question: question, user: user, best: false)

    answer2.update!(best: true)

    expect(answer1.reload.best?).to be false
    expect(answer2.reload.best?).to be true
  end

  context 'best scope applied' do
    it 'returns the best answer the first' do
      user = create(:user)
      question = create(:question, user: user)
      create(:answer, question: question, user: user, best: false)
      create(:answer, question: question, user: user, best: true)
      first_answer_in_list = Answer.best_first.first

      expect(first_answer_in_list).to be_best
    end
  end
end
