require_dependency 'project'
require_dependency 'principal'

module RedmineBooks
  module Patches

    module PrincipalPatch
      def self.included(base)
        base.class_eval do
          unloadable
          after_destroy :destroy_permissions

          private

          def destroy_permissions
             PrincipalBooksPermission.delete(self.id)
          end
        end
      end

    end

  end
end

unless Principal.included_modules.include?(RedmineBooks::Patches::PrincipalPatch)
  Principal.send(:include, RedmineBooks::Patches::PrincipalPatch)
end
