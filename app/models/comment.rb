# frozen_string_literal: true
class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  scope :best_first, -> { order(best: :desc, created_at: :asc) }
  scope :order_by_create, -> { order(created_at: :asc) }

  validates :body, presence: true
  validates :user_id, :commentable_id, :commentable_type, presence: true
end
