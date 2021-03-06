# frozen_string_literal: true
class AnswerSerializer < BaseBodySerializer
  attributes :question_id

  has_many :comments
  has_many :attachments
end
