# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
end
