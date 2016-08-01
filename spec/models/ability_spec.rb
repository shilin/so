require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for logged in user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question) }
    let(:comment) { create(:comment, user: user, commentable_type: :question, commentable_id: question.id) }
    let(:another_user_comment) { create(:comment, user: another_user, commentable_type: :question, commentable_id: question.id) }

    context 'to have guest abilities' do
      it { should_not be_able_to :manage, :all }

      it { should be_able_to :read, :all }
    end

    context 'to create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end


    context 'to update' do
      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: another_user) }

      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:question, user: another_user) }

      it { should be_able_to :update, comment }
      it { should_not be_able_to :update, another_user_comment }
    end

    context 'to destroy' do
      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: another_user) }

      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: another_user) }

      it { should be_able_to :destroy, comment }
      it { should_not be_able_to :destroy, another_user_comment }
    end

    context 'to vote' do

      Ability::VOTE_ACTIONS.each do |va|
        Ability::VOTABLE_KLASSES.each do |vk|
          it { should be_able_to va.to_s.underscore.to_sym, create(vk.to_s.underscore.to_sym, user: another_user) }
          it { should_not be_able_to va.to_s.underscore.to_sym, create(vk.to_s.underscore.to_sym, user: user) }
        end
      end
    end

    context 'to set_best' do
      let(:question) { create(:question, user: user) }
      let(:another_user_question) { create(:question, user: another_user) }

      it { should be_able_to :set_best, create(:answer, question: question) }
      it { should_not be_able_to :set_best, create(:answer, question: another_user_question) }
    end
  end
end
