class PagesController < ApplicationController
  before_action :set_categories, only: [:index]

  def show
    if valid_page?
      render template: "pages/#{params[:slug]}"
    else
      # return 404
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private
  def valid_page?
    File.exist?(Pathname.new(Rails.root + "app/views/pages/#{params[:slug]}.html.erb"))
  end
end
