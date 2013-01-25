class BookRecord < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  belongs_to :returned_by, class_name: "User"
  validate :current_book_record_for_book_must_be_uniq
  validates :user, :book, :taken_at, presence: true

  private

  def current_book_record_for_book_must_be_uniq
    if self.book && self.book.current_book_record && self.book.current_book_record != self
      errors.add(:current_book_record_uniqueness, l(:error_current_book_record_uniqueness_violation))
    end
  end
end
