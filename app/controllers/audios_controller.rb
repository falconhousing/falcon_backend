class AudiosController < ApplicationController
  before_action :set_audio, only: [:show, :edit, :update, :destroy]
  FACTORY = RGeo::Geographic.simple_mercator_factory

  VM_ADD = "http://dharmendrav.housing.com:4000"
  
  
  # GET /audios
  # GET /audios.json
  def index
    @audios = Audio.all
  end

  # GET /audios/1
  # GET /audios/1.json
  def show
    debugger
  end

  def get_all_audios
    all_obj = Audio.all
    audio = all_obj.as_json
    count = 0
    audio.each do |i|
      i[:audio_url] = VM_ADD+all_obj[count].audio.url
      count+=1
    end
    render json: audio
  end
  
  
  # GET /audios/new
  def new
    @audio = Audio.new
  end

  # GET /audios/1/edit
  def edit
  end

  # POST /audios
  # POST /audios.json
  def create
    params = set_coordinates_from_lat_long(audio_params)
    @audio = Audio.new(params)
    respond_to do |format|
      if @audio.save
        format.html { redirect_to @audio, notice: 'Audio was successfully created.' }
        format.json { render action: 'show', status: :created, location: @audio }
      else
        format.html { render action: 'new' }
        format.json { render json: @audio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audios/1
  # PATCH/PUT /audios/1.json
  def update
    respond_to do |format|
      if @audio.update(audio_params)
        format.html { redirect_to @audio, notice: 'Audio was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @audio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audios/1
  # DELETE /audios/1.json
  def destroy
    @audio.destroy
    respond_to do |format|
      format.html { redirect_to audios_url }
      format.json { head :no_content }
    end
  end

  def set_coordinates_from_lat_long(params)
    if(params.has_key?('latitude') && params.has_key?('longitude'))
      latitude = params[:latitude].strip
      longitude = params[:longitude].strip
      if /^[0-9]+(\.[0-9]+)?$/.match(latitude).nil? || /^[0-9]+(\.[0-9]+)?$/.match(longitude).nil?
        params[:coordinates] = nil
      else
        params[:coordinates] = FACTORY.point(longitude.to_f.round(6), latitude.to_f.round(6))
      end
    end
    params.except!(:latitude, :longitude)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = Audio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audio_params
      params.permit(:audio, :latitude, :longitude, :trip_id, :acl)
    end
end
