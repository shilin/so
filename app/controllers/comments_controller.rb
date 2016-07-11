class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  respond_to :js

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      flash.now[:notice] = 'Your comment has been submitted!'
    else
      flash.now[:alert] = 'Unable to submit your comment'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    @commentable = model_klass.find(model_id)
  end

  def model_klass
    request.fullpath.split('/')[1].classify.constantize
  end

  def model_id
    request.fullpath.split('/')[2]
  end
end
