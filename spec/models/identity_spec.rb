# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:provider).scoped_to(:uid) }
end
