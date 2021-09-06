class SessionsOfTheDaysController < ApplicationController
  before_action :set_sessions_of_the_day, only: %i[ show edit update destroy ]

  # GET /sessions_of_the_days or /sessions_of_the_days.json
  def index
    @sessions_of_the_days = SessionsOfTheDay.all
  end

  # GET /sessions_of_the_days/1 or /sessions_of_the_days/1.json
  def show
  end

  # GET /sessions_of_the_days/new
  def new
    @sessions_of_the_day = SessionsOfTheDay.new
  end

  # GET /sessions_of_the_days/1/edit
  def edit
  end

  # POST /sessions_of_the_days or /sessions_of_the_days.json
  def create
    @sessions_of_the_day = SessionsOfTheDay.new(sessions_of_the_day_params)

    respond_to do |format|
      if @sessions_of_the_day.save
        format.html { redirect_to @sessions_of_the_day, notice: "Sessions of the day was successfully created." }
        format.json { render :show, status: :created, location: @sessions_of_the_day }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sessions_of_the_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions_of_the_days/1 or /sessions_of_the_days/1.json
  def update
    respond_to do |format|
      if @sessions_of_the_day.update(sessions_of_the_day_params)
        format.html { redirect_to @sessions_of_the_day, notice: "Sessions of the day was successfully updated." }
        format.json { render :show, status: :ok, location: @sessions_of_the_day }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sessions_of_the_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions_of_the_days/1 or /sessions_of_the_days/1.json
  def destroy
    @sessions_of_the_day.destroy
    respond_to do |format|
      format.html { redirect_to sessions_of_the_days_url, notice: "Sessions of the day was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sessions_of_the_day
      @sessions_of_the_day = SessionsOfTheDay.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sessions_of_the_day_params
      params.fetch(:sessions_of_the_day, {})
    end
end
