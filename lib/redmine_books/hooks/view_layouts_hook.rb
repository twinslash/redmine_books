module RedmineBooks
  module Hooks
    class ViewLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head context={}
        return stylesheet_link_tag(:book_general, :plugin => 'redmine_books')
      end
    end
  end
end
