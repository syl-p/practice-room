class SearchController < ApplicationController
  def index
    @results = SearchService.new.call(search_params[:search], current_user)
  end

  def search_params
    params.permit(:search)
  end
end
