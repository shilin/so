class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :load_question, only: [:create]
  before_action :check_authorship, only: [:update, :destroy]

  respond_to :js, :json

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update_attributes(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @question = @answer.question
    if question_author && @answer.set_as_best
      flash[:notice] = 'Answer has been successfully set as best'
    else
      flash[:alert] = 'Unable to set answer as best'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def check_authorship
    return if author
    render status: :forbidden, text: 'Only author is allowed to perform this action'
  end

  def author
    current_user && (current_user.id == @answer.user_id)
  end

  def question_author
    current_user && (current_user.id == @answer.question.user_id)
  end
end
