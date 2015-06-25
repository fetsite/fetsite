class BeispieleController < ApplicationController
  # GET /beispiele
  
  load_and_authorize_resource
  include LikeVoteable
  acts_as_flagable
  def index
    @beispiele = Beispiel.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beispiele }
    end
  end
  
  # GET /beispiele/1
  # GET /beispiele/1.json
  def show
    # @lva = params([:lva]) unless params([:lva]).nil?
    @beispiel = Beispiel.find(params[:id])
    respond_to do |format|
      format.html { redirect_to lva_path(@beispiel.lva )}
      format.js
    end
  end

  # GET /beispiele/new
  # GET /beispiele/new.json
  def new
    @beispiel = Beispiel.new
    @beispiel.lva = Lva.find_by_id(params[:lva_id])
    @backlink = @beispiel.lva.nil? ? root_url : lva_path(@beispiel.lva)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beispiel }
    end
  end

  # GET /beispiele/1/edit
  def edit
    @beispiel = Beispiel.find(params[:id])
  end

  # POST /beispiele
  # POST /beispiele.json
  def create
    logger.info "Creating Beispiel..."
    @lva = Lva.find_by_id(params[:lva_id])
    params.delete(:lva_id)
    @beispiel = Beispiel.new(params[:beispiel])

    logger.info "New Beispiel: #{params.inspect}"
    
    @beispiel.name=@beispiel.beispieldatei.filename
    logger.info "New Beispiel: #{@beispiel.attributes.inspect}"


    respond_to do |format|
      unless @lva.nil? 
        @beispiel.lva=@lva
            @beispiel.datum=Time.now
        if @beispiel.save
          format.html {
            render :json => [@beispiel.to_jq_upload].to_json,
                   :content_type => 'text/html',
                   :layout => false
          }
          format.json { render json: {files: [@beispiel.to_jq_upload]}, status: :created, location: [@lva, @beispiel] }
        #    format.html { redirect_to @backlink, notice: 'Beispiel was successfully created.' }
        #    format.json { render json: @beispiel, status: :created, location: @beispiel }
        else
          format.html { render action: "new" }
          format.json { render json: @beispiel.errors, status: :unprocessable_entity }
        end
      else
        if @beispiel.update_attributes(params[:beispiel])
          @backlink = Lva.find(@beispiel.lva)
          format.html { redirect_to @backlink, notice: 'Beispiel was successfully uploaded.'}
          format.json { head :no_content }
        else
          format.html { render action: "new" }
          format.json { render json: @beispiel.errors, status: :unprocessable_entity }
        end
      end

      
    end
  end

  # PUT /beispiele/1
  # PUT /beispiele/1.json
  def update
    @beispiel = Beispiel.find(params[:id])
    @beispiel.name=@beispiel.beispieldatei.to_s.split('/').last
    @backlink = @beispiel.lva.nil? ? root_url : lva_path(@beispiel.lva)
    params[:beispiel].delete :beispieldatei
    params[:beispiel].delete :beispieldatei_cache
    @lva = @beispiel.lva
    respond_to do |format|
      if @beispiel.update_attributes(params[:beispiel])
        format.html { redirect_to @backlink, notice: 'Beispiel was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beispiel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beispiele/1
  # DELETE /beispiele/1.json
  def destroy
    @beispiel = Beispiel.find(params[:id])
    @backlink = @beispiel.lva.nil? ? root_url : lva_path(@beispiel.lva)
    @beispiel.destroy

    respond_to do |format|
      format.html { redirect_to @backlink  }
      format.json { head :no_content }
    end
  end
end
