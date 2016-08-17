require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns unauthorized status if there is no access_token' do
        get api_v1_questions_path, format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized status if access_token is invalid' do
        get api_v1_questions_path, format: :json, access_token: '1234'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get api_v1_questions_path, format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'is included in parent question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end

        it 'contains exactly required attributes' do
          expect(JSON.parse(response.body)['questions'][0]['answers'][0].keys).to contain_exactly('id', 'question_id', 'body', 'created_at', 'updated_at')
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable_type: 'Question', attachable_id: question.id) }
    let!(:comment) { create(:comment, commentable_type: 'Question', commentable_id: question.id) }

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access_token' do
        get api_v1_question_path(question), format: :json, access_token: '1234'
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized status if access_token is invalid' do
        get api_v1_question_path(question), format: :json, access_token: '1234'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do
      before { get api_v1_question_path(question), format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      it 'contains exactly required attributes' do
        expect(JSON.parse(response.body)['question']['answers'][0].keys).to contain_exactly('id', 'question_id', 'body', 'created_at', 'updated_at')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('question/short_title')
      end

      context 'comments' do
        it 'is included in parent question' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end

        it 'contains exactly required attributes' do
          expect(JSON.parse(response.body)['question']['comments'][0].keys).to contain_exactly('id', 'body', 'created_at', 'updated_at')
        end
      end

      context 'attachments' do
        it 'is included in parent question' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/url')
        end

        it 'contains only url attribute' do
          expect(JSON.parse(response.body)['question']['attachments'][0].keys).to contain_exactly('url')
        end
      end

      context 'answers' do
        it 'is included in parent question' do
          expect(response.body).to have_json_size(1).at_path('question/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end

        it 'contains exactly required attributes' do
          expect(JSON.parse(response.body)['question']['answers'][0].keys).to contain_exactly('id', 'question_id', 'body', 'created_at', 'updated_at')
        end
      end
    end
  end
end
