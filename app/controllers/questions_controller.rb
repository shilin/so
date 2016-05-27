class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
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
    @question = Question.find(params[:id])
    if current_user && current_user.id == @question.user.id && @question.destroy
      flash[:notice] = "Question has been successfully deleted"
      redirect_to questions_path
    else
      flash[:error] = "You are not permitted to delete the question"
      redirect_to question_path(@question)
    end
  end


  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end

end
