class AttachmentsController < ApplicationController
  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @attachment = Attachment.new
    @thema = Thema.find(params[:thema_id])
	@attachment.thema = @thema
	
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
    @thema = @attachment.thema
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(params[:attachment])
    @thema = Thema.find(params[:thema_id])
	@attachment.thema_id = @thema.id
	
    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @thema, notice: 'Attachment was successfully created.' }
        format.json { render json: @thema, status: :created, location: @thema }
      else
        format.html { render action: "new" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])
	@thema = @attachment.thema
	
    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to @thema, notice: 'Attachment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    @thema = Thema.find(params[:thema_id])

    respond_to do |format|
      format.html { redirect_to @thema }
      format.json { head :no_content }
    end
  end
end
