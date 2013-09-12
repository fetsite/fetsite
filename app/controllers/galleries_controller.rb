class GalleriesController < ApplicationController
  before_filter {@toolbar_elements=[]}
  load_and_authorize_resource

  # GET /galleries
  # GET /galleries.json
  def index
    @galleries = Gallery.all
    @toolbar_elements << {:hicon => 'icon-plus', :text => I18n.t('fotos.new-gallery'), :path => new_gallery_path }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @galleries }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.json
  def show
    @gallery = Gallery.find(params[:id])

    @pppage_array = [ 25 , 50 , 100 ] #defines number & size of picture chunks
    @pppage = 0 #starting index of pppage_array
    
    if params[:pppage].to_i <= 2 && params[:pppage].to_i >= 0
      @pppage = params[:pppage].to_i
    end
      
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @fotos = Foto.where(:gallery_id => params[:id]).limit(@pppage_array[@pppage]).offset(@pppage_array[@pppage]*(@page-1))
    @pages = (Foto.where(:gallery_id => params[:id]).count/(@pppage_array[@pppage])+1)
    @toolbar_elements << {:hicon=>'icon-plus', :text=> I18n.t('fotos.new-fotos'), :path=>new_gallery_foto_path(@gallery)}
    @toolbar_elements << {:hicon=>'icon-pencil', :text => I18n.t('common.edit'), :path=>edit_gallery_path(@gallery)}
    @toolbar_elements << {:hicon=>'icon-arrow-left', :text=>I18n.t('common.back'), :path=>galleries_path()}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.json
  def new
    @gallery = Gallery.new
    @foto = Foto.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
  end

  # POST /galleries
  # POST /galleries.json
  def create
    @gallery = Gallery.new(params[:gallery])
    @foto = Foto.new
    respond_to do |format|
      if @gallery.save
        format.html { redirect_to @gallery, notice: 'Gallery was successfully created.' }
        format.json { render json: @gallery, status: :created, location: @gallery }
      else
        format.html { render action: "new" }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.json
  def update
    @gallery = Gallery.find(params[:id])
    @foto = Foto.new
    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        format.html { redirect_to @gallery, notice: 'Gallery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.json
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to galleries_url }
      format.json { head :no_content }
    end
  end
end
