# frozen_string_literal: true
require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable_type: 'Answer', attachable_id: answer.id) }
    let!(:comment) { create(:comment, commentable_type: 'Answer', commentable_id: answer.id) }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { get api_v1_question_answers_path(question), format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      it 'contains exactly required attributes' do
        expect(JSON.parse(response.body)['answers'][0].keys)
          .to contain_exactly('id', 'question_id', 'body', 'comments', 'attachments', 'created_at', 'updated_at')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def make_request(options = {})
      get api_v1_question_answers_path(question), { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable_type: 'Answer', attachable_id: answer.id) }
    let!(:comment) { create(:comment, commentable_type: 'Answer', commentable_id: answer.id) }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { get api_v1_answer_path(answer), format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      it 'contains exactly required attributes' do
        pp api_v1_answer_path(answer)
        expect(JSON.parse(response.body)['answer'].keys)
          .to contain_exactly('id', 'question_id', 'body', 'comments', 'attachments', 'created_at', 'updated_at')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'is included in parent question' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end

        it 'contains exactly required attributes' do
          expect(JSON.parse(response.body)['answer']['comments'][0].keys).to contain_exactly('id', 'body', 'created_at', 'updated_at')
        end
      end

      context 'attachments' do
        it 'is included in parent question' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/url')
        end

        it 'contains only url attribute' do
          expect(JSON.parse(response.body)['answer']['attachments'][0].keys).to contain_exactly('url')
        end
      end
    end

    def make_request(options = {})
      get api_v1_answer_path(answer), { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let!(:user) { User.find(access_token.resource_owner_id) }

        it 'returns CREATED status' do
          post api_v1_question_answers_path(question), answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to have_http_status :created
        end

        it 'assigns answer to the current user and question and saves it into the DB ' do
          expect do
            post api_v1_question_answers_path(question),
                 answer: attributes_for(:answer),
                 format: :json,
                 access_token: access_token.token
          end.to change(user.answers, :count).by(1)
          expect do
            post api_v1_question_answers_path(question),
                 answer: attributes_for(:answer),
                 format: :json,
                 access_token: access_token.token
          end.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns unprocessable_entity status' do
          post api_v1_question_answers_path(question),
               answer: attributes_for(:invalid_answer),
               format: :json,
               access_token: access_token.token

          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not save question into DB' do
          expect do
            post api_v1_question_answers_path(question),
                 answer: attributes_for(:invalid_answer),
                 format: :json,
                 access_token: access_token.token
          end.to_not change(Question, :count)
        end
      end
    end

    def make_request(options = {})
      post api_v1_question_answers_path(question), {
        answer: attributes_for(:answer), format: :json
      }.merge(options)
    end
  end
end
