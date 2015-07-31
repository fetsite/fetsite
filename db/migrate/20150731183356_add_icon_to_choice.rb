class AddIconToChoice < ActiveRecord::Migration
  def change
    add_column :survey_choices, :icon, :string
  end
end
