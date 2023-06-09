class Exercises::VersionsController < ApplicationController
  before_action :set_exercise , only: %i[index]
  def index
    @versions = @exercise.versions_filtered(current_user)
  end

  private
  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end
end
