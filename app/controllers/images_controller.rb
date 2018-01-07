class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @images = Image.all
    else
      redirect_to root_url
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
      redirect_to root_url
    end
  end

  # GET /images/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @image = Image.new
    else
      redirect_to root_url
    end
  end

  # GET /images/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
      redirect_to root_url
    end
  end

  # POST /images
  # POST /images.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @image = Image.new(image_params)
      respond_to do |format|
        if @image.save
          format.html { redirect_to @image, notice: 'Image was successfully created.' }
          format.json { render :show, status: :created, location: @image }
        else
          format.html { render :new }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @image.update(image_params)
          format.html { redirect_to @image, notice: 'Image was successfully updated.' }
          format.json { render :show, status: :ok, location: @image }
        else
          format.html { render :edit }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end 
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @image.destroy
      @image.remove_url!
      respond_to do |format|
        format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:url, :description)
    end
end
