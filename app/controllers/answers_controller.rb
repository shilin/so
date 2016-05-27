class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))

    if @answer.save
      flash[:notice] = 'Your answer has been submitted!'
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
