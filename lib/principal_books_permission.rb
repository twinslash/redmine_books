class PrincipalBooksPermission
  attr_accessor :principal, :actions

  def initialize(principal, actions)
    @principal = principal
    @actions = actions
  end

  def self.all(conditions = {})
    return [] unless validates_permissions
    principals_permissions = permissions
    principals = Principal.where(["id IN (?)", principals_permissions.keys]).where(conditions)
    principals.map do |principal|
      actions = principals_permissions[principal.id.to_s]
      self.new(principal, actions) unless actions.blank?
    end.compact
  end

  def self.create(principal, actions)
    new(principal, actions).instance_eval do
      return false unless validates_principal!
      return false unless validates_actions!
      save
    end
  end

  def self.delete(principal)
    permission = find(principal)
    permission.delete if permission
  end

  def self.allows?(principal_id, action)
    permission = find(principal_id)
    return permission && permission.allows?(action)
  end

  def self.find(principal)
    principal_id = get_principal_id(principal)
    actions = validates_permissions && permissions[principal_id]
    new(principal, actions)
  end

  def <<(permission)
    @actions = [] unless @actions.is_a?(Array)
    if permission.is_a?(PrincipalBooksPermission) && permission.actions.is_a?(Array)
      @actions += permission.actions
    elsif permission.is_a?(Array)
      @actions += permission
    elsif permission.is_a?(String) || permission.is_a?(Symbol)
      @actions << permission.to_s
    end
    @actions.uniq!
  end

  def delete
    permissions = self.class.validates_permissions ? self.class.permissions : {}
    principal_id = get_principal_id
    permissions.delete(principal_id)
    Setting.plugin_redmine_books = Setting.plugin_redmine_books.merge(principals_books_permissions: permissions)
  end

  def allows?(action)
    return false unless action.is_a?(String) || action.is_a?(Symbol)
    return @actions.is_a?(Array) && @actions.include?(action.to_s)
  end

  private

  def self.get_principal_id principal
    return principal.id.to_s if principal.is_a?(Principal)
    principal.to_s
  end

  def self.permissions
    Setting.plugin_redmine_books[:principals_books_permissions]
  end

  def self.validates_permissions
    return permissions.is_a?(Hash)
  end

  def validates_principal!
    return true if @principal.is_a?(Principal) && @principal.persisted?
    return false unless (@principal = Principal.find_by_id(@principal.to_s))
    return true
  end

  def validates_actions!
    @actions ||= []
    return false unless @actions.is_a?(Array)
    @actions.uniq!
    @actions.select! do |action|
      action.respond_to?('to_sym') && action.to_sym.in?(RedmineBooks.available_principal_books_actions)
    end
    return true
  end

  def save
    permissions = self.class.permissions
    permissions = {} unless self.class.validates_permissions
    permissions.merge!({ @principal.id.to_s => @actions })
    Setting.plugin_redmine_books = Setting.plugin_redmine_books.merge(principals_books_permissions: permissions)
  end

  def get_principal_id
    self.class.get_principal_id @principal
  end
end
