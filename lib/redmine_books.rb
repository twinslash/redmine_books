require 'principal_books_permission'

Rails.configuration.to_prepare do
  require_dependency 'redmine_books/hooks/view_layouts_hook'
  require_dependency 'redmine_books/patches/principal_patch'
end

module RedmineBooks
  def self.available_principal_books_actions
    [:edit, :add, :delete, :take, :give_instead_user]
  end

  def self.include_action?(action)
    action.respond_to?(:to_sym) && available_principal_books_actions.include?(action.to_sym)
  end

  def self.settings() Setting[:plugin_redmine_books] end

  def self.principals_books_permissions() Setting.plugin_redmine_books[:principals_books_permissions] || {} end

  def self.url_exists?(url)
    require_dependensy 'open-uri'
    begin
      open(url)
      true
    rescue
      false
    end
  end
end

#'public/tmp' folder for temporary storage of images that the user chooses to book
tempstore_path = File.expand_path('public/tmp', Rails.root)
Dir.mkdir(tempstore_path) unless Dir.exists?(tempstore_path)
