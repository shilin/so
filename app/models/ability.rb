class Ability
  VOTE_ACTIONS = [:upvote, :downvote, :unvote, :vote_upon].freeze
  VOTABLE_KLASSES = [Question, Answer].freeze

  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :me, :profile

    can :create, [Question, Answer, Comment, Subscription]

    can :update, Question, user: user
    can :update, Answer, user: user
    can :update, Comment, user: user

    can :destroy, Question, user: user
    can :destroy, Answer, user: user
    can :destroy, Comment, user: user
    can :destroy, Subscription, user: user

    VOTE_ACTIONS.each do |va|
      VOTABLE_KLASSES.each do |vk|
        can va, vk do |subject|
          subject.user_id != user.id
        end
      end
    end

    can :set_best, Answer do |answer|
      answer.question.user_id == user.id
    end
  end
end
