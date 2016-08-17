require 'rails_helper'

describe 'Answers API' do
  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachable_type: 'Answer', attachable_id: answer.id) }
    let!(:comment) { create(:comment, commentable_type: 'Answer', commentable_id: answer.id) }

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access_token' do
        get api_v1_answer_path(answer), format: :json, access_token: '1234'
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized status if access_token is invalid' do
        get api_v1_answer_path(answer), format: :json, access_token: '1234'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do
      before { get api_v1_answer_path(answer), format: :json, access_token: access_token.token }

      it 'returns OK status' do
        expect(response).to have_http_status :ok
      end

      it 'contains exactly required attributes' do
        pp api_v1_answer_path(answer)
        expect(JSON.parse(response.body)['answer'].keys).to contain_exactly('id', 'question_id', 'body', 'comments', 'attachments', 'created_at', 'updated_at')
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
  end
end
