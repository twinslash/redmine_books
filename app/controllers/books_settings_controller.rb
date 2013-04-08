class BooksSettingsController < ApplicationController
  unloadable
  layout 'admin'
  before_filter :require_admin
  before_filter :find_principals_books_permissions, only: [:index]

  def index
    @users, @groups = [User, Group].map { |c| c.active.all order: 'type, login, lastname', limit: 100 }
  end

  def autocomplete_for_users
    @principals = Module.const_get(params[:model_name]).active.like(params[:q]).all(order: 'type, login, lastname ASC', limit: 100)
    render layout: false
  rescue NameError
    render nothing: true
  end

  def create
    @principals_ids = params[:principals_ids]
    @actions = params[:actions]
    if @principals_ids.blank?
      render nothing: true
      return
    end
    @principals_ids.each do |principal_id|
      PrincipalBooksPermission.create(principal_id, @actions)
    end
    find_principals_books_permissions
    respond_to do |format|
      format.html { redirect_to books_settings_path }
      format.js
    end
  end

  def destroy
    PrincipalBooksPermission.delete(params[:id])
    find_principals_books_permissions
    respond_to do |format|
      format.html { redirect_to books_settings_path }
      format.js
    end
  end

  private
    def find_principals_books_permissions
      @users_permissions = PrincipalBooksPermission.all(type: "User")
      @groups_permissions = PrincipalBooksPermission.all(type: "Group")
    end
end
