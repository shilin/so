class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :index, :create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
    redirect_to @question if current_user && current_user.id != @question.user.id
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    if @question.save
      flash[:notice] = 'Your question has been successfully created!'
      redirect_to @question
    else
      flash[:alert] = 'Error creating your question!'
      render :new
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
