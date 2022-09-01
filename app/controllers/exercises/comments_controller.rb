class Exercises::CommentsController < ApplicationController
    include Commentable
    before_action :set_commentable
    skip_authorization_check :index

    def index
      @comments = @commentable.comments.where(parent_id: nil).order(updated_at: :desc)
    end

    private

    def set_commentable
        @commentable = Exercise.find(params[:exercise_id])
    end
end
