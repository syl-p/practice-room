class MediaController < ApplicationController
  before_action :set_medium, only: %i[ show edit update destroy ]
  authorize_resource

  # GET /media or /media.json
  def index
    @media = Medium.all
  end

  def me
    @media = current_user.media
    render :index
  end

  # GET /media/1 or /media/1.json
  def show
  end

  # GET /media/new
  def new
    @medium = Medium.new
  end

  # GET /media/1/edit
  def edit
  end

  # POST /media or /media.json
  def create
    @medium = Medium.new(medium_params)
    @medium.user_id = current_user.id

    respond_to do |format|
      if @medium.save
        if params["medium"]["exercise_id"].present?
          format.html { redirect_to edit_with_step_exercises_path(params["medium"]["exercise_id"], step: 'media'), notice: 'Medium was successfully created.' }
        else
          format.turbo_stream
          format.html { redirect_to edit_medium_path(@medium), notice: "Medium was successfully created." }
          format.json { render :show, status: :created, location: @medium }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media/1 or /media/1.json
  def update
    respond_to do |format|
      if @medium.update(medium_params)
        format.html { redirect_to @medium, notice: "Medium was successfully updated." }
        format.json { render :show, status: :ok, location: @medium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media/1 or /media/1.json
  def destroy
    @medium.destroy
    respond_to do |format|
      format.html { redirect_to media_url, notice: "Medium was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium
      @medium = Medium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medium_params
      params.require(:medium).permit(:name, :description, :file)
    end
end
