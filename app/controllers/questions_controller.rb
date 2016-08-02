class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  authorize_resource
  before_action :load_question, except: [:new, :index, :create]
  before_action :check_authorship, only: [:destroy, :update]
  before_action :gon_current_user, only: [:show, :index]

  respond_to :js, :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update_attributes(question_params)
    respond_with(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def check_authorship
    return if author
    render status: :forbidden, text: 'Only author is allowed to perform this action'
  end

  def author
    current_user && (current_user.id == @question.user_id)
  end

  def gon_current_user
    gon.currentUserId = (current_user && current_user.id)
  end
end
