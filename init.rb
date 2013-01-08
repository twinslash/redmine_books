require 'redmine_books'

Redmine::Plugin.register :redmine_books do
  name 'Redmine Books plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  settings default: { users_books_permissions: {} }
  menu :admin_menu, :books, {controller: 'books_settings', action: 'index'}, caption: :label_books
  menu :top_menu, :books, {controller: 'books', action: 'index'}, caption: :label_books
end
