require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module RedmineBooks
  module Patches

    module PrincipalPatch
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
              PrincipalBooksPermission.delete id
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
              book.is_a?(Book) && book.busy? && (book.user == self)
            when "give_instead_user"
              (admin? || @user_books_permission.allows?(action)) && book.is_a?(Book) && book.busy? && book.user && (book.user != self)
            when "delete", "destroy"
              action = "delete"
              admin? || @user_books_permission.allows?(action)
            else
              false
            end
        end

      end
    end

  end
end

unless Principal.included_modules.include?(RedmineBooks::Patches::PrincipalPatch)
  Principal.send(:include, RedmineBooks::Patches::PrincipalPatch)
end
