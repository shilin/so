shared_examples_for 'commentable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:commentable) { create(model.to_s.underscore.to_sym, user: user) }

  it { should have_many(:comments).dependent(:destroy) }

  # describe 'votable#rating' do
  #   it 'sums up votes' do
  #     create_list(:upvote, 5, votable: votable)
  #     create_list(:downvote, 3, votable: votable)
  #     expect(votable.rating).to eq 2
  #   end
  # end
end
