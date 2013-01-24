class BookRecord < ActiveRecord::Base
  belongs_to :book, include: :user
  belongs_to :user
  belongs_to :returned_by, class_name: "User"
  validates :user, :book, :taken_at, presence: true
end
