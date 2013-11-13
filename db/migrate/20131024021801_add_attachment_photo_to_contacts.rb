class AddAttachmentPhotoToContacts < ActiveRecord::Migration
  def self.up
    change_table :contacts do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :contacts, :photo
  end
end
