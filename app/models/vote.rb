# frozen_string_literal: true
class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable_id, :votable_type, :user_id, presence: true
  validates :votable_id, uniqueness: { scope: [:votable_type, :user_id] }
  validates :state, inclusion: { in: (-1..1) }
end
