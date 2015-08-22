class AddFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :flag_getemails, :boolean, default: 0
    add_column :users, :flag_delete, :boolean, default: 0
  end
end
