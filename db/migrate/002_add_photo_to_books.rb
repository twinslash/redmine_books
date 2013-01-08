class AddPhotoToBooks <  ActiveRecord::Migration
  def self.up
    add_attachment :books, :photo
  end

  def self.down
    remove_attachment :books, :photo
  end
end
