class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true
  validates :question_id, presence: true
end