class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))

    if @answer.save
      flash.now[:notice] = 'Your answer has been submitted!'
    else
      flash.now[:alert] = 'Unable to submit your answer'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    if current_user && (current_user.id == @answer.user_id) && @answer.update_attributes(answer_params)
      flash[:notice] = 'Answer has been successfully updated'
    else
      flash[:alert] = 'Unable to update the answer'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user && (current_user.id == @answer.user_id) && @answer.destroy
      flash[:notice] = 'Answer has been successfully deleted'
    else
      flash[:alert] = 'You are not permitted to delete the answer'
    end
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
