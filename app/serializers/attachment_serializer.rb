# frozen_string_literal: true
class AttachmentSerializer < ActiveModel::Serializer
  attributes :url

  def url
    object.file.url
  end
end
