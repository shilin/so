shared_examples_for 'votable' do
  let(:author) { create(:user) }
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym, user: author) }

  describe 'votable has many votes' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#rating' do
    it 'sums up votes' do
      create_list(:upvote, 5, votable: votable)
      create_list(:downvote, 3, votable: votable)
      expect(votable.rating).to eq 2
    end
  end
end
