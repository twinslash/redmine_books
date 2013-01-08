class UserBooksPermission
  attr_accessor :user_id, :actions

  def initialize user_id, actions
    @user_id = user_id
    @actions = actions
  end

  def self.all
    return [] unless validates_permissions
    permissions.map do |user_id, actions|
      self.new(user_id, actions)
    end
  end

  def self.create user_id, actions
    new(user_id, actions).save
  end

  def self.delete user_id
    new(user_id, nil).save
  end

  def self.allows? user_id, action
    permission = find(user_id)
    return permission && permission.allows?(action)
  end

  def self.find user
    return nil unless user.is_a?(User) || User.find_by_id(user)
    user_id =  if user.is_a?(User)
      user.id.to_s
    else
      user.to_s
    end
    actions = validates_permissions && permissions[user_id]
    new(user_id, actions)
  end

  def save
    return false unless validates_user_id!
    return false unless validates_actions!
    permissions = self.class.permissions
    permissions = {} unless self.class.validates_permissions
    if actions.blank?
      permissions.delete @user_id
    else
      permissions.merge!({ @user_id => @actions })
    end
    Setting.plugin_redmine_books = Setting.plugin_redmine_books.merge(users_books_permissions: permissions)
  end

  def user
    User.find(@user_id)
  end

  def allows? action
    return false unless action.is_a?(String) || action.is_a?(Symbol)
    return @actions && @actions.respond_to?('include?') && @actions.include?(action.to_s)
  end

  private
    def self.permissions
      Setting.plugin_redmine_books[:users_books_permissions]
    end

    def self.validates_permissions
      return permissions && permissions.is_a?(Hash)
    end

    def validates_user_id!
      @user_id = @user_id.to_s
      return false unless User.find_by_id(@user_id)
      return true
    end

    def validates_actions!
      @actions = @actions || []
      return false unless @actions.is_a?(Array) || @actions.blank?
      unless @actions.blank?
        @actions.uniq!
        @actions.select! do |action|
          action.respond_to?('to_sym') && action.to_sym.in?(RedmineBooks.available_user_books_actions)
        end
      end
      return true
    end
end
