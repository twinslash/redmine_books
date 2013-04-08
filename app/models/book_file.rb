class BookFile < ActiveRecord::Base
  attr_accessible :file, :file_cache
  mount_uploader :file, FileUploader
  validates :file, presence: true
  belongs_to :book
end
