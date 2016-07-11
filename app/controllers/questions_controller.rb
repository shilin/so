class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :index, :create]

  def index
    @questions = Question.all
    (@question = Question.new).attachments.build if current_user
  end

  def show
    @comment = @question.comments.build

    @answer = @question.answers.build
    @answer.attachments.build
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    if @question.save
      flash[:notice] = 'Your question has been successfully created!'
    else
      flash[:alert] = 'Error creating your question!'
    end
  end

  def destroy
    if current_user && current_user.id == @question.user.id && @question.destroy
      flash[:notice] = 'Question has been successfully deleted'
      redirect_to questions_path
    else
      flash[:error] = 'You are not permitted to delete the question'
      redirect_to question_path(@question)
    end
  end

  def update
    if current_user && (current_user.id == @question.user.id) && @question.update_attributes(question_params)
      flash[:notice] = 'Question has been successfully updated'
    else
      flash[:error] = 'Unable to update question'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
