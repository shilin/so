module MockOmniAuthMacros
  def mock_auth_hash(provider, email)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(provider: provider,
                                                                        uid: '123456',
                                                                        info: { email: email })
  end

  def mock_auth_hash_invalid
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end
