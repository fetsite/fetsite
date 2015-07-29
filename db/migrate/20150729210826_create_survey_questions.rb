class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.string :title
      t.text :text
      t.integer :typ
      t.string :parent_type
      t.integer :parent_id
      t.timestamps
    end
  end
end
