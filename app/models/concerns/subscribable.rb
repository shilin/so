# frozen_string_literal: true
module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, as: :subscribable, dependent: :destroy

    after_create :subscribe_author

    private

    def subscribe_author
      Subscription.create(user: user, subscribable: self)
    end
  end
end
