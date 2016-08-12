class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  authorize_resource

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    @commentable = model_klass.find(model_id)
  end

  def model_klass
    params[:commentable].classify.constantize
  end

  def model_id
    params["#{model_klass.name.downcase}_id"]
  end
end
