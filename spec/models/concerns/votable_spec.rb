shared_examples_for 'votable' do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym, user: author) }

  describe 'votable has many votes' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'votable#rating' do
    it 'sums up votes' do
      create_list(:upvote, 5, votable: votable)
      create_list(:downvote, 3, votable: votable)
      expect(votable.rating).to eq 2
    end
  end

  describe 'votable#upvote' do
    it 'upvotes a votable' do
      expect { votable.upvote(user) }.to change(votable, :rating).by(1)
    end
  end

  describe 'votable#downvote' do
    it 'downvotes a votable' do
      expect { votable.downvote(user) }.to change(votable, :rating).by(-1)
    end
  end

  describe 'votable#unvote'
end
