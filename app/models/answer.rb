class Answer < ActiveRecord::Base
  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  before_save :ensure_answers_unbest, if: ->() { best_changed? }

  protected

  def ensure_answers_unbest
    Answer.where(question_id: question_id, best: true).update_all(best: false)
  end
end
