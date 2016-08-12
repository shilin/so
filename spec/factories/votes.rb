FactoryGirl.define do
  factory :upvote, class: Vote do
    state(1)
    user
  end

  factory :downvote, class: Vote do
    state(-1)
    user
  end

  factory :unvote, class: Vote do
    state 0
    user
  end
end
