require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'calls request method' do
      expect(Search).to receive(:query).with('111', 'all')
      get :search, search_what: '111', search_resource: 'all'
    end
    #
    it 'renders search template' do
      get :search, search_what: '', search_resource: 'all'

      expect(response).to render_template 'search'
    end
  end
end
