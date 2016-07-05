module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    if @votable.upvote(current_user)
      render json: { rating: @votable.rating, message: 'Question has been successfully upvoted' }, status: :ok
    else
      render json: { message: 'Unable to upvote' }, status: :unprocessable_entity
    end
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
