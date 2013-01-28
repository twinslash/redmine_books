require File.expand_path('../../uploaders/file_uploader', __FILE__)

class Book < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:ebook, :will_be_purchased, :busy, :free], default: :ebook, predicates: :true
  attr_accessible :author, :book_files, :book_files_attributes, :description, :photo, :status, :title
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  has_many :book_files, dependent: :destroy
  accepts_nested_attributes_for :book_files, allow_destroy: :true
  has_many :book_records, dependent: :destroy, include: [:user, :returned_by], inverse_of: :book
  has_many :archived_book_records, class_name: :BookRecord, conditions: ["#{BookRecord.table_name}.returned_at IS NOT :null AND #{BookRecord.table_name}.returned_by_id IS NOT :null", { null: nil }], include: [:user, :returned_by]
  has_one :current_book_record, class_name: :BookRecord, conditions: ["#{BookRecord.table_name}.returned_at IS :null AND #{BookRecord.table_name}.returned_by_id IS :null", { null: nil }], include: [:user]
  validates :title, :author, presence: true, length: { in: 2..100 }
  validate :book_with_current_book_record_must_be_busy

  def paper?
    free? || busy?
  end

  private

  def book_with_current_book_record_must_be_busy
    if !busy? && current_book_record(true).present?
      errors.add(:status, :must_be_busy_because_current_user_present)
    end
  end
end
