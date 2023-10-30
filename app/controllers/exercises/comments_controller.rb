class Exercises::CommentsController < ApplicationController
    include Commentable
    before_action :authenticate_user!, except: :index
    before_action :set_commentable

    def index
      @comments = @commentable.comments.where(parent_id: nil).order(created_at: :desc)
    end

    private

    def set_commentable
        @commentable = Exercise.find(params[:exercise_id])
    end
end
