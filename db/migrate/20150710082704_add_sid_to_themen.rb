class AddSidToThemen < ActiveRecord::Migration
  def change
    add_column :themen,:sid, :string
    add_index :themen,:sid, unique: true
  end
end
