# frozen_string_literal: true
class Question < ActiveRecord::Base
  include Votable
  include Commentable
  include Subscribable

  scope :posted_yesterday, -> { where(created_at: Time.zone.now.yesterday.all_day) }

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
