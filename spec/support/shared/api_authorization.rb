shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'returns unauthorized status if there is no access_token' do
      make_request
      expect(response).to have_http_status :unauthorized
    end

    it 'returns unauthorized status if access_token is invalid' do
      make_request(access_token: '1234')
      expect(response).to have_http_status :unauthorized
    end
  end
end
