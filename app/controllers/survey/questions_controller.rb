class Survey::QuestionsController < ApplicationController
  # GET /survey/questions
  # GET /survey/questions.json
  def index
    @survey_questions = Survey::Question.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @survey_questions }
    end
  end
  def answer
    @survey_question = Survey::Question.find(params[:id])
    @survey_question.do_answer(params[:survey_question][:selected],current_user)
    render :show
  end
  # GET /survey/questions/1
  # GET /survey/questions/1.json
  def show
    @survey_question = Survey::Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @survey_question }
    end
  end

  # GET /survey/questions/new
  # GET /survey/questions/new.json
  def new
    @survey_question = Survey::Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @survey_question }
    end
  end

  # GET /survey/questions/1/edit
  def edit
    @survey_question = Survey::Question.find(params[:id])
  end

  # POST /survey/questions
  # POST /survey/questions.json
  def create
    @survey_question = Survey::Question.new(params[:survey_question])

    respond_to do |format|
      if @survey_question.save
        format.html { redirect_to @survey_question, notice: 'Question was successfully created.' }
        format.json { render json: @survey_question, status: :created, location: @survey_question }
      else
        format.html { render action: "new" }
        format.json { render json: @survey_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /survey/questions/1
  # PUT /survey/questions/1.json
  def update
    @survey_question = Survey::Question.find(params[:id])

    respond_to do |format|
      if @survey_question.update_attributes(params[:survey_question])
        format.html { redirect_to @survey_question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @survey_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey/questions/1
  # DELETE /survey/questions/1.json
  def destroy
    @survey_question = Survey::Question.find(params[:id])
    @survey_question.destroy

    respond_to do |format|
      format.html { redirect_to survey_questions_url }
      format.json { head :no_content }
    end
  end
end
