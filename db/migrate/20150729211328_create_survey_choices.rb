class CreateSurveyChoices < ActiveRecord::Migration
  def change
    create_table :survey_choices do |t|
      t.string :text
      t.references :question
      t.integer :sort
      t.string :picture

      t.timestamps
    end
    add_index :survey_choices, :question_id
  end
end
