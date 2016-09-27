# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe 'fulltext search' do
    it 'returns search_resources' do
      expect(Search::SEARCH_RESOURCES).to eq %w(all user question answer comment).freeze
    end

    it 'gets request' do
      request = 'test@user.com'
      ts_query = ThinkingSphinx::Query.escape(request)
      expect(ThinkingSphinx::Query).to receive(:escape).with(request).and_call_original
      expect(ThinkingSphinx).to receive(:search).with(ts_query)
      Search.query(request, 'all')
    end
  end

  it 'returns empty array if context is invalid' do
    user = create(:user)
    create(:question, user: user)
    index

    expect(Search.query('', 'invalid')).to match_array []
  end
end
