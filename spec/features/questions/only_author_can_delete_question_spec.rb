require 'rails_helper'

feature 'Only author is able to delete a question', %q{
  In order to remove bad question
  As an author
  I want to be able to delete  question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  context "Author" do
    before { sign_in(author) }
    scenario 'deletes a question' do
      visit question_path(question)
      click_on 'Delete'
      expect(page).to have_content "Question has been successfully deleted"
    end
  end
end

