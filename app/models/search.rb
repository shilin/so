# frozen_string_literal: true
class Search
  SEARCH_RESOURCES = %w(all user question answer comment).freeze

  def self.query(request, search_resource)
    request = ThinkingSphinx::Query.escape(request)
    return [] unless SEARCH_RESOURCES.include? search_resource
    if search_resource == 'all'
      ThinkingSphinx.search request
    else
      search_resource.classify.constantize.search request
    end
  end
end
