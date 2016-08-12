class AddPolymorphicToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :attachable, polymorphic: true, index: true
  end
end
