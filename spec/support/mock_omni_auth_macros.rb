module MockOmniAuthMacros
  def mock_auth_hash(email)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook',
                                                                  uid: '123456',
                                                                  info: { email: email })
  end

  def mock_auth_hash_invalid
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end
