module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    user && (user.id != user_id) && votes.where(user: user).first_or_initialize.update_attributes(state: 1)
  end

  def downvote(user)
    user && (user.id != user_id) && votes.where(user: user).first_or_initialize.update_attributes(state: -1)
  end

  def unvote(user)
    user && (user.id != user_id) && votes.where(user: user).first_or_initialize.update_attributes(state: 0)
  end

  def rating
    votes.sum(:state)
  end
end
