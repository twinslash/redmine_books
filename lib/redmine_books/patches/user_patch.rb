require_dependency 'principal'
require_dependency 'user'
require_dependency 'project'

module RedmineBooks
  module Patches

    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          has_many :book_records, dependent: :destroy
          has_many :archived_book_records, class_name: :BookRecord, conditions: ["#{BookRecord.table_name}.returned_at IS NOT :null AND #{BookRecord.table_name}.returned_by_id IS NOT :null", { null: nil }]
          has_many :current_book_records, class_name: :BookRecord, conditions: ["#{BookRecord.table_name}.returned_at IS :null AND #{BookRecord.table_name}.returned_by_id IS :null", { null: nil }]
          has_many :books, through: :current_book_records

          # make User model able to rate objects
          ajaxful_rater

          before_destroy :does_not_have_books?

          private

          def does_not_have_books?
            return false if self.books.where(status: "busy").any?
            return true
          end
        end
      end

      module InstanceMethods
        def allowed_books_to?(action, book = nil)
          action = action.to_s
          unless @user_books_permission
            @user_books_permission = PrincipalBooksPermission.find(self)
            self.groups.each do |group|
              @user_books_permission << PrincipalBooksPermission.find(group)
            end
          end
          allowed = case action
            when "add", "new", "create"
              action = "add"
              admin? || @user_books_permission.allows?(action)
            when "edit", "update"
              action = "edit"
              admin? || @user_books_permission.allows?(action)
            when "take"
              (@user_books_permission.allows?(action) || admin?) && book.is_a?(Book) && book.free?
            when "give"
              book.is_a?(Book) && book.busy? && book.current_book_record && (book.current_book_record.user == self)
            when "give_instead_user"
              (admin? || @user_books_permission.allows?(action)) && book.is_a?(Book) && book.busy? && book.current_book_record && (book.current_book_record.user != self)
            when "delete", "destroy"
              action = "delete"
              admin? || @user_books_permission.allows?(action)
            when "estimate"
              true
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
