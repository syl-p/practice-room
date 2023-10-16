class SearchController < ApplicationController
  def index
    return unless search_params[:search].present?
    @results = SearchService.new.call(search_params[:search], current_user)
  end

  def search_params
    params.permit(:search)
  end
end
