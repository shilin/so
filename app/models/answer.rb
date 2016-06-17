class Answer < ActiveRecord::Base
  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def set_as_best
    transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
