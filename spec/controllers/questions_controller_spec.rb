require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    it 'populates an array of all questions' do
      questions = FactoryGirl.create_list(:question, 2)

      get :index

      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index

      expect(response).to render_template :index
    end
  end

end
