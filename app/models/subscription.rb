# frozen_string_literal: true
class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribable, polymorphic: true

  validates :user_id, :subscribable_id, :subscribable_type, presence: true
  validates :subscribable_id, uniqueness: { scope: [:subscribable_type, :user_id] }
end
