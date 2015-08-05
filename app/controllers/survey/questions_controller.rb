class Survey::QuestionsController < ApplicationController
  # GET /survey/questions
  # GET /survey/questions.json
  load_and_authorize_resource
  acts_as_flagable
  def index
    @survey_questions = Survey::Question.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def answer
    @survey_question = Survey::Question.find(params[:id])    
    if (params[:key].nil? || params[:key].empty?) 
      user = current_user
    else
      k=Key.find_by_uuid(params[:key]  )
      if k.is_valid && k.typ==3 && k.parent == @survey_question
        user = k.user
      end
    end
    
    @survey_question.do_answer(params[:survey_question][:selected],user)
    respond_to do |format|
      format.html { redirect_to action: :show}
      format.js { render action: :show}
    end
  end
  # GET /survey/questions/1
  # GET /survey/questions/1.json
  def show
    @survey_question = Survey::Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /survey/questions/new
  # GET /survey/questions/new.json
  def new
    @survey_question = Survey::Question.new
    @commentable=params[:commentable_type].constantize.find(params[:commentable_id]) 
    respond_to do |format|
      format.html # new.html.erb
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
      else
        format.html { render action: "new" }
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
      else
        format.html { render action: "edit" }
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

    end
  end
end
