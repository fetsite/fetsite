class CalentriesController < ApplicationController
  # GET /calentries
  # GET /calentries.json
  load_and_authorize_resource
  def index
    

    respond_to do |format|
      format.html {redirect_to rubriken_path}
   end
 end

  # GET /calentries/1
  # GET /calentries/1.json
  def show
    @calentry = Calentry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @calentry }
      format.ics  { render 'show.ics.erb'}
    end
  end

  # GET /calentries/new
  # GET /calentries/new.json
 def new
   @calentry = Calentry.new
   @calentry.object=params[:object_type].constantize.find(params[:object_id])
   @calentry.typ=1
   respond_to do |format|
     format.html # new.html.erb
     format.json { render json: @calentry }
        format.js
   end
 end

  # GET /calentries/1/edit
  def edit
    @calentry = Calentry.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /calentries
  # POST /calentries.json
 def create
   @calentry = Calentry.new(params[:calentry])

    respond_to do |format|
      if @calentry.save
        format.html { redirect_to @calentry, notice: 'Calentry was successfully created.' }
        format.json { render json: @calentry, status: :created, location: @calentry }
        format.js
      else
       format.html { render action: "new" }
        format.json { render json: @calentry.errors, status: :unprocessable_entity }
        format.js { render action: "new" }
end
    end
  end

  # PUT /calentries/1
  # PUT /calentries/1.json
  def update
    @calentry = Calentry.find(params[:id])

    respond_to do |format|
      if @calentry.update_attributes(params[:calentry])
        format.html { redirect_to @calentry, notice: 'Calentry was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @calentry.errors, status: :unprocessable_entity }
        format.js { render action: "edit"}
      end
    end
  end

  # DELETE /calentries/1
  # DELETE /calentries/1.json
  def destroy
    logger.info("-------------delete------------------")
    @calentry = Calentry.find(params[:id])
    @calentry_id = params[:id]  
    @object=@calentry.object
    @calentry.destroy
    
    respond_to do |format|
      format.html { redirect_to @object}
      format.json { head :no_content }
      format.js 
    end
  end
end
