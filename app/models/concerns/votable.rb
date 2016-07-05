module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    user && (user.id != self.user_id) && votes.create(user: user, state: 1)
  end

  def rating
    votes.sum(:state)
  end
end
