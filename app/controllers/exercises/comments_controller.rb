class Exercises::CommentsController < ApplicationController
    include Commentable
    before_action :set_commentable

    private

    def set_commentable
        @commentable = Exercise.find(params[:exercise_id])
    end
end
