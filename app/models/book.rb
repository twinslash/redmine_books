require File.expand_path('../../uploaders/file_uploader', __FILE__)

class Book < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:ebook, :will_be_purchased, :busy, :free], default: :ebook, predicates: :true
  attr_accessible :author, :book_files, :book_files_attributes, :description, :photo, :status, :title
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  has_many :book_files, dependent: :destroy
  has_many :book_records, dependent: :destroy, include: [:user, :returned_by]
  has_one :current_book_record, class_name: "BookRecord", foreign_key: "current_book_id"
  belongs_to :user
  validates :title, :author, presence: true, length: { in: 2..100 }
  accepts_nested_attributes_for :book_files, allow_destroy: :true
end
