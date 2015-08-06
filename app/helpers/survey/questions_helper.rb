module Survey::QuestionsHelper
  def new_question_for(obj)
    render partial: "survey/questions/new_question", locals: {question_templates: Survey::Question.templates, parent: obj}
  end
end
