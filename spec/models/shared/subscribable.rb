shared_examples_for 'subscribable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:subscribable) { create(model.to_s.underscore.to_sym, user: user) }

  it { should have_many(:subscriptions).dependent(:destroy) }
end
