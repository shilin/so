# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'attachable'
  it_behaves_like 'subscribable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :title }
  it { should validate_presence_of :user_id }
end
