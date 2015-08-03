class AddTemplateToSurveyQuestion < ActiveRecord::Migration
  def change
    add_column :survey_questions, :flag_template, :boolean
    add_column :survey_questions, :flag_deleted, :boolean
    add_column :survey_questions, :flag_intern,:boolean
    add_column :survey_questions, :user_id, :integer
    add_column :survey_questions, :flag_locked, :boolean
  end
end
