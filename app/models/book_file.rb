require 'file_size_validator'

class BookFile < ActiveRecord::Base
  attr_accessible :file, :file_cache
  mount_uploader :file, FileUploader
  validates :file, presence: true, file_size: { maximum: 10.megabytes.to_i }
  belongs_to :book
end
