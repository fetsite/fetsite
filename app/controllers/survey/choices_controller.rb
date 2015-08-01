class Survey::ChoicesController < ApplicationController
  # GET /survey/choices
  # GET /survey/choices.json
  def index
    @survey_choices = Survey::Choice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @survey_choices }
    end
  end

  # GET /survey/choices/1
  # GET /survey/choices/1.json
  def show
    @survey_choice = Survey::Choice.find(params[:id])

    respond_to do |format|
      format.html {redirect_to @survey_choice.question}
      format.json { render json: @survey_choice }
      format.js
    end
  end

  # GET /survey/choices/new
  # GET /survey/choices/new.json
  def new
    @question= Survey::Question.find(params[:question_id])

    @choice=Survey::Choice.new
    @choice.question=@question
    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.json { render json: @survey_choice }
    end
  end

  # GET /survey/choices/1/edit
  def edit
    @choice = Survey::Choice.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /survey/choices
  # POST /survey/choices.json
  include PluginsHelper
  def create
    @survey_choice = Survey::Choice.new(params[:survey_choice])
    @divid = divid_for(@survey_choice) 
    
    respond_to do |format|
      if @survey_choice.save
        format.html { redirect_to @survey_choice, notice: 'Choice was successfully created.' }
        format.json { render json: @survey_choice, status: :created, location: @survey_choice }
        format.js 
      else
        format.html { render action: "new" }
        format.json { render json: @survey_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /survey/choices/1
  # PUT /survey/choices/1.json
  def update
    @survey_choice = Survey::Choice.find(params[:id])

    respond_to do |format|
      if @survey_choice.update_attributes(params[:survey_choice])
        format.html { redirect_to @survey_choice, notice: 'Choice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @survey_choice.errors, status: :unprocessable_entity }
5      end
    end
  end

  # DELETE /survey/choices/1
  # DELETE /survey/choices/1.json
  def destroy
    @survey_choice = Survey::Choice.find(params[:id])
    @survey_choice.destroy

    respond_to do |format|
      format.html { redirect_to survey_choices_url }
      format.json { head :no_content }
    end
  end
end
