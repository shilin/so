module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    if @votable.upvote(current_user)
      render json: { id: @votable.id, rating: @votable.rating, message: 'Question has been successfully upvoted' }, status: :ok
    else
      render json: { id: @votable.id, message: 'Unable to upvote' }, status: :unprocessable_entity
    end
  end

  def downvote
    if @votable.downvote(current_user)
      render json: { id: @votable.id, rating: @votable.rating, message: 'Question has been successfully downvoted' }, status: :ok
    else
      render json: { id: @votable.id, message: 'Unable to downvote' }, status: :unprocessable_entity
    end
  end

  def unvote
    if @votable.unvote(current_user)
      render json: { id: @votable.id, rating: @votable.rating, message: 'Question has been successfully unvoted' }, status: :ok
    else
      render json: { id: @votable.id, message: 'Unable to unvote' }, status: :unprocessable_entity
    end
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
