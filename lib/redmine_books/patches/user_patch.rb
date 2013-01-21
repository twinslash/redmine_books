require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module RedmineBooks
  module Patches

    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          has_many :book_records, dependent: :destroy
          has_many :books

          before_destroy :does_not_have_books?
          private
            def does_not_have_books?
              return false if self.books.where(status: "busy").any?
              UserBooksPermission.delete id
              return true
            end
        end
      end

      module InstanceMethods

        def allowed_books_to? action, book = nil
          @user_books_permission ||= UserBooksPermission.find(self)
          action = action.to_s
          return true if admin? && ["take_book", "take", "return_book", "give"].exclude?(action)
          allowed = case action
            when "add", "new", "create"
              action = "add"
              @user_books_permission.allows? action
            when "edit", "update"
              action = "edit"
              @user_books_permission.allows? action
            when "take"
              (@user_books_permission.allows?(action) || admin?) && book.is_a?(Book) && book.free?
            when "return", "give"
              book.is_a?(Book) && book.busy? && (book.user == self)
            when "delete", "destroy"
              action = "delete"
              @user_books_permission.allows? action
            else
              false
            end
        end

      end
    end

  end
end

unless User.included_modules.include?(RedmineBooks::Patches::UserPatch)
  User.send(:include, RedmineBooks::Patches::UserPatch)
end
