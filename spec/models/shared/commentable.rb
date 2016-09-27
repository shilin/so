# frozen_string_literal: true
shared_examples_for 'commentable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:commentable) { create(model.to_s.underscore.to_sym, user: user) }

  it { should have_many(:comments).dependent(:destroy) }
end
