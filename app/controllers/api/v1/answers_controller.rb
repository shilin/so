class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :get_question, except: :show

  def index
    respond_with @question.answers
  end

  def show
    respond_with Answer.find(params[:id])
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end
end
