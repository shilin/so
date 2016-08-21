require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'attachable'

  it "ensures all question's answers made unbest" do
    answer1 = create(:answer, question: question, user: user, best: true)
    answer2 = create(:answer, question: question, user: user, best: false)

    answer2.set_as_best

    expect(answer1.reload.best?).to be false
    expect(answer2.reload.best?).to be true
  end

  it 'sets the best answer' do
    answer = create(:answer, question: question, user: user, best: false)
    create(:answer, question: question, user: user, best: false)
    create(:answer, question: question, user: user, best: true)

    answer.set_as_best

    expect(answer).to be_best
  end

  context 'best scope applied' do
    it 'returns the best answer the first' do
      create(:answer, question: question, user: user, best: false)
      create(:answer, question: question, user: user, best: true)
      first_answer_in_list = Answer.best_first.first

      expect(first_answer_in_list).to be_best
    end
  end
end
