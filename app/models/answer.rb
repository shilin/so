# frozen_string_literal: true
class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  after_commit :notify, on: :create

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def set_as_best
    transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify
    QuestionNotificationJob.perform_later(question) if persisted?
  end
end
