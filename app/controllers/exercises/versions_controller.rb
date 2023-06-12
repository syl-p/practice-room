class Exercises::VersionsController < ApplicationController
  before_action :set_exercise , only: %i[index new]
  def index
    @versions = @exercise.versions_filtered(current_user)
  end

  def new
    @version = Exercise.new
    @version.original = @exercise
  end

  def create
    @version = Exercise.new(exercise_params)
    @version.user_id = current_user.id
    respond_to do |format|
      if @exercise.save
        format.html { redirect_to edit_exercise_version_path(@version), notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @version }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "exercise_versions",
            partial: "exercises/versions/form",
            locals: {
              version: @version
            }
          )
        }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end
end
