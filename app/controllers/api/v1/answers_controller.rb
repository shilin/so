class Api::V1::AnswersController < Api::V1::BaseController
  def show
    respond_with Answer.find(params[:id])
  end
end
