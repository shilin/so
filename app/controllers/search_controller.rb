class SearchController < ApplicationController
  authorize_resource

  def search
    @search = Search.query(params[:search_what], params[:search_resource])
  end
end
