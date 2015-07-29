class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.references :choice
      t.references :user

      t.timestamps
    end
    add_index :survey_answers, :choice_id
    add_index :survey_answers, :user_id
  end
end
