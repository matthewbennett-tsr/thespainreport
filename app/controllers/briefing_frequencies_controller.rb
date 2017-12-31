class BriefingFrequenciesController < ApplicationController
  before_action :set_briefing_frequency, only: [:show, :edit, :update, :destroy]

  # GET /briefing_frequencies
  # GET /briefing_frequencies.json
  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @briefing_frequencies = BriefingFrequency.all
    else
    end
  end

  # GET /briefing_frequencies/1
  # GET /briefing_frequencies/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
    end
  end

  # GET /briefing_frequencies/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @briefing_frequency = BriefingFrequency.new
    else
    end
  end

  # GET /briefing_frequencies/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
    end
  end

  # POST /briefing_frequencies
  # POST /briefing_frequencies.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @briefing_frequency = BriefingFrequency.new(briefing_frequency_params)
      respond_to do |format|
        if @briefing_frequency.save
          format.html { redirect_to @briefing_frequency, notice: 'Briefing frequency was successfully created.' }
          format.json { render :show, status: :created, location: @briefing_frequency }
        else
          format.html { render :new }
          format.json { render json: @briefing_frequency.errors, status: :unprocessable_entity }
        end
      end
    else
    end
  end

  # PATCH/PUT /briefing_frequencies/1
  # PATCH/PUT /briefing_frequencies/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @briefing_frequency.update(briefing_frequency_params)
          format.html { redirect_to @briefing_frequency, notice: 'Briefing frequency was successfully updated.' }
          format.json { render :show, status: :ok, location: @briefing_frequency }
        else
          format.html { render :edit }
          format.json { render json: @briefing_frequency.errors, status: :unprocessable_entity }
        end
      end
    else
    end
  end

  # DELETE /briefing_frequencies/1
  # DELETE /briefing_frequencies/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
     @briefing_frequency.destroy
      respond_to do |format|
        format.html { redirect_to briefing_frequencies_url, notice: 'Briefing frequency was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_briefing_frequency
      @briefing_frequency = BriefingFrequency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def briefing_frequency_params
      params.require(:briefing_frequency).permit(:name, :briefing_frequency)
    end
end
