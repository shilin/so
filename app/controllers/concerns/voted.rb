module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    @vote = @votable.votes.build
    @vote.user_id = current_user.id
    @vote.state = 1

    if current_user && (current_user.id != @votable.user_id) && @vote.save
        render json: { rating: @votable.rating, message: 'Question has been successfully upvoted' }, status: :ok
      else
        render json:  @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def set_votable
    @votable = model_class.find(params[:id])
  end

  def model_class
    controller_name.classify.constantize
  end
end
