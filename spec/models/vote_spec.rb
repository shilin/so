# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_uniqueness_of(:votable_id).scoped_to([:votable_type, :user_id]) }
  it { should validate_inclusion_of(:state).in_range(-1..1) }
end
