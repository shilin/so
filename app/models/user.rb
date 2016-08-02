class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:twitter, :facebook]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :identities, dependent: :destroy

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid.to_s).first

    return identity.user if identity

    email = auth.info[:email] if auth.info

    return User.new unless email

    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 19]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.create_identity(auth)

    user
  end

  def create_identity(auth)
    identities.create!(provider: auth.provider, uid: auth.uid.to_s)
  end
end
