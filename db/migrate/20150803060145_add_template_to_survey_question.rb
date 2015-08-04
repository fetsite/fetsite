class AddTemplateToSurveyQuestion < ActiveRecord::Migration
  def up
    add_column :survey_questions, :flag_template, :boolean, :default => 0
   add_column :survey_questions, :flag_delete, :boolean, :default => 0
    add_column :survey_questions, :flag_intern,:boolean, :default => 0
    add_column :survey_questions, :user_id, :integer
    add_column :survey_questions, :flag_locked, :boolean, :default => 0
    add_column :survey_questions, :flag_multiplechoice, :boolean, :default => 0
    add_column :survey_questions, :sort, :integer
    add_column :survey_questions, :flag_hidden, :boolean, :default => 0
    add_column :survey_questions, :flag_emailed, :boolean, :default => 0
  end
def down

    remove_column :survey_questions, :flag_template
   remove_column :survey_questions, :flag_delete
    remove_column :survey_questions, :flag_intern
    remove_column :survey_questions, :user_id
    remove_column :survey_questions, :flag_locked
    remove_column :survey_questions, :flag_multiplechoice
    remove_column :survey_questions, :sort
    remove_column :survey_questions, :flag_hidden
    remove_column :survey_questions, :flag_emailed

end
end
