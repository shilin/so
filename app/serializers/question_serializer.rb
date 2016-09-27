# frozen_string_literal: true
class QuestionSerializer < BaseBodySerializer
  attributes :title, :short_title
  has_many :answers
  has_many :comments
  has_many :attachments

  def short_title
    object.title.truncate(10)
  end
end
