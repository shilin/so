require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :title }
  it { should validate_presence_of :user_id }
end
