class Identity < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :provider, :uid, presence: true
  validates :provider, uniqueness: { scope: :uid }
end
