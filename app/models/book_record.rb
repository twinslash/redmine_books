class BookRecord < ActiveRecord::Base
  belongs_to :book, inverse_of: :book_records
  belongs_to :user
  belongs_to :returned_by, class_name: "User"
  validates :user, :book, :taken_at, presence: true
  before_save "self.book(true).busy?"
  before_create :ensure_uniqueness_of_current_book_record_for_book
  before_update :ensure_current_book_record_for_book

  def archived?
    returned_at.blank? && returned_by.blank?
  end

  private

  def ensure_uniqueness_of_current_book_record_for_book
    self.book && !self.book.current_book_record(true)
  end

  def ensure_current_book_record_for_book
    self.book && self.book.current_book_record(true) == self
  end
end
