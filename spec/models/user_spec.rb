# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:identities).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth_facebook) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:auth_twitter) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    context 'user already has identity' do
      context 'of facebook' do
        it 'returns the user' do
          user.identities.create(provider: 'facebook', uid: '123456')

          expect(User.find_for_oauth(auth_facebook)).to eq user
        end
      end

      context 'of twitter' do
        it 'returns the user' do
          user.identities.create(provider: 'twitter', uid: '123456')

          expect(User.find_for_oauth(auth_twitter)).to eq user
        end
      end
    end

    context 'user has no identity' do
      # let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'}) }

      context 'already exists in DB' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'creates identity for user' do
          expect { User.find_for_oauth(auth) }.to change(user.identities, :count).by(1)
        end

        it 'creates identity with right provider and uid for user' do
          identity = User.find_for_oauth(auth).identities.first
          expect(identity.provider).to eq 'facebook'
          expect(identity.uid).to eq '123456'
        end

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
      end

      context 'and user does not exist in DB' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count)
        end

        it 'creates identity' do
          expect { User.find_for_oauth(auth) }.to change(Identity, :count).by(1)
        end

        it 'creates identity with right provider and uid for user' do
          new_user = User.find_for_oauth(auth)
          identity = new_user.identities.first

          expect(identity.provider).to eq 'facebook'
          expect(identity.uid).to eq '123456'
          expect(identity.user).to eq new_user
        end
      end
    end
  end
end
