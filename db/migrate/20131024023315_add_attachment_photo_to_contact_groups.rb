class AddAttachmentPhotoToContactGroups < ActiveRecord::Migration
  def self.up
    change_table :contact_groups do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :contact_groups, :photo
  end
end
