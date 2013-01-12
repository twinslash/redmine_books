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
              books.each do |book|
                return false if book.busy?
              end
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
            when "add_book", "new", "create"
              action = "add_book"
              @user_books_permission.allows? action
            when "edit_book", "edit", "update"
              action = "edit_book"
              @user_books_permission.allows? action
            when "take_book", "take"
              action = "take_book"
              (@user_books_permission.allows?(action) || admin?) && book.is_a?(Book) && book.free?
            when "return_book", "give"
              book.is_a?(Book) && book.busy? && (book.user == self)
            when "delete_book", "destroy"
              action = "delete_book"
              @user_books_permission.allows? action
            else
              false
            end
          return allowed
        end

      end
    end

  end
end

unless User.included_modules.include?(RedmineBooks::Patches::UserPatch)
  User.send(:include, RedmineBooks::Patches::UserPatch)
end
