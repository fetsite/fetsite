class AddDateiToAttachment < ActiveRecord::Migration
  def change
	add_column :attachments, :datei, :string
  end
end
