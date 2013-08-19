class FragenController < ApplicationController
  # GET /fragen
  # GET /fragen.json
  def index
    @fragen = Frage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fragen }
    end
  end

  # GET /fragen/1
  # GET /fragen/1.json
  def show
    @frage = Frage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @frage }
    end
  end

  # GET /fragen/new
  # GET /fragen/new.json
  def new
    @frage = Frage.new

    respond_to do |format|
      format.html
      format.json { render json: @frage }
    end
  end

  # GET /fragen/1/edit
  def edit
    @frage = Frage.find(params[:id])
  end

  # POST /fragen
  # POST /fragen.json
  def create
    @frage = Frage.new(params[:frage])

    respond_to do |format|
      if @frage.save
        format.html { redirect_to @frage.thema, notice: 'Frage was successfully created.' }
        format.json { render json: @frage, status: :created, location: @frage }
      else
        format.html { render action: "new" }
        format.json { render json: @frage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fragen/1
  # PUT /fragen/1.json
  def update
    @frage = Frage.find(params[:id])

    respond_to do |format|
      if @frage.update_attributes(params[:frage])
        format.html { redirect_to @frage, notice: 'Frage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @frage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fragen/1
  # DELETE /fragen/1.json
  def destroy
    @frage = Frage.find(params[:id])
    @frage.destroy

    respond_to do |format|
      format.html { redirect_to @frage.thema }
      format.json { head :no_content }
    end
  end
end
