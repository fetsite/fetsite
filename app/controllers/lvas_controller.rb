class LvasController < ApplicationController
  # GET /lvas
  require 'zip'
  before_filter :load_toolbar, :only => [:verwalten]
  load_and_authorize_resource
  before_filter :load_studien
  def load_studien
        @studien = Studium.accessible_by(current_ability, :show)
  end
  def index
    @lvas = Lva.all
    @toolbar_elements=[{:hicon=>'icon-plus-sign',:text =>I18n.t('lva.add'),:path => new_lva_path}]
    @tb=[{:hicon=>'icon-list', :text=>I18n.t("studien.allestudien"),:path=>studien_path},
         {:hicon=>'icon-list', :text=>I18n.t("modul.list"),:path=>moduls_path},
         {:hicon=>'icon-list', :text=>I18n.t("lva.list"),:path=>lvas_path}]
  end
  def beispiel_sammlung
    @lva = Lva.find_by_id(params[:id])
    #Attachment name
    filename = 'beispiel_sammlung_' + @lva.lvanr.to_s + '_' + l(Date.today).to_s + '.zip'
    temp_file = Tempfile.new(filename) 
    begin
      #This is the tricky part
      #Initialize the temp file as a zip file
      Zip::OutputStream.open(temp_file) { |zos| }
      #Add files to the zip file as usual
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        #Put files in here
        i=1
        @lva.beispiele.each do |bsp|
          zip.add(i.to_s + '_' + File.basename(bsp.beispieldatei.current_path), bsp.beispieldatei.current_path)
          i = i + 1
        end
        
      end
      #Read the binary data from the file
      zip_data = File.read(temp_file.path)
      send_data(zip_data, :type => 'application/zip', :filename => filename)
    ensure
      #Close and delete the temp file
      temp_file.close
      temp_file.unlink
    end
  end
  # GET /lvas/1

  def show
    @lva = Lva.find_by_id(params[:id])
    @beispiel=Beispiel.new
    @beispiele_all=@lva.beispiele.order(:datum).accessible_by(current_ability, :show)
    @beispiele = @lva.beispiele.not_flag_badquality.not_flag_delete.order(:lecturer_id,:datum).accessible_by(current_ability, :show)
    @beispiele_badQ = @lva.beispiele.flag_badquality.not_flag_delete.order(:datum).accessible_by(current_ability, :show)
    @beispiele_deleted = @lva.beispiele.flag_delete.order(:datum).accessible_by(current_ability, :show)
    @toolbar_elements =[]
    @toolbar_elements<<{:hicon=>'icon-pencil', :icon=>:pencil,:text =>I18n.t('common.manage'),:path => verwalten_lva_path(@lva)} if can? :verwalten, @lva
     @crawlobjects = @lva.crawlobjects.roots.accessible_by(current_ability)
  end
  def verwalten
    @lva = Lva.find_by_id(params[:id])
    @beispiel=Beispiel.new

    render :show
  end

  # GET /lvas/new
  # GET /lvas/new.json
  def new
    @lva = Lva.new
    modul=Modul.find_by_id(params[:modul_id])
    @lva.modul<<modul unless modul.nil? #
    
  end

  # GET /lvas/1/edit
  def edit
    @lva = Lva.find(params[:id])
    @semester =  @lva.modul.map(&:modulgruppen).flatten.map(&:studium).map(&:semester).flatten.uniq
  end

  def compare_tiss
    @lva = Lva.find_by_id(params[:id])
    @lvatiss = Lva.new
    @lvatiss.lvanr=@lva.lvanr
    @lvatiss.load_tissdata
 
  end
  
  def load_tiss
    @lva = Lva.find_by_id(params[:id])
    @lva.load_tissdata
    if @lva.save
      redirect_to @lva , notice: 'Lva von TISS geladen.'
    else
      redirect_to @lva, action: :compare_tiss
    end
  end

  def create
    @lva = Lva.new(params[:lva])
    respond_to do |format|
      if @lva.save
        @lva.add_semesters
        format.html { redirect_to @lva, notice: 'Lva was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @lva = Lva.find(params[:id])
    respond_to do |format|
      if @lva.update_attributes(params[:lva])
        @lva.add_semesters
        format.html { redirect_to @lva, notice: 'Lva was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @lva = Lva.find(params[:id])
    @lva.destroy

    respond_to do |format|
      format.html { redirect_to lvas_url }
    end
  end

private
  def load_toolbar
    @lva = Lva.find_by_id(params[:id])
    @toolbar_elements =[]
    @toolbar_elements<<{:hicon=>'icon-pencil', :icon=>:pencil,:text =>I18n.t('common.edit'),:path => edit_lva_path(@lva)} if can? :edit, @lva
    @toolbar_elements << {:hicon=>'icon-remove-circle', :text=>"Tissvergleichladen", :path=> compare_tiss_lva_path(@lva)} if can? :compare_tiss, @lva
    @toolbar_elements << {:hicon=>'icon-remove-circle', :text=>I18n.t('lva.delete'), :path=> lva_path(@lva), :method=>:delete, :confirm=>t('lva.deletesure') } if can? :delete, @lva




  end

end
