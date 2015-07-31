class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type
      t.text :text
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.boolean :hidden
      t.boolean :official
      t.boolean :intern
      t.boolean :anonym
      t.timestamps
    end
  end
end
