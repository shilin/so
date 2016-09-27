# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :subscribable }
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :subscribable_id }
  it { should validate_presence_of :subscribable_type }
  it { should validate_uniqueness_of(:subscribable_id).scoped_to([:subscribable_type, :user_id]) }
end
