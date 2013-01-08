class BooksSettingsController < ApplicationController
  unloadable
  layout 'admin'
  before_filter :require_admin
  before_filter :find_users_books_permissions, only: [:index]

  def index
  end

  def autocomplete_for_users
    @principals = Principal.active.like(params[:q]).all(limit: 100, order: 'type, login, lastname ASC')
    render layout: false
  end

  def create
    @user_ids = params[:user_ids]
    actions = params[:actions]
    return if @user_ids.blank?
    @user_ids.each do |user_id|
      UserBooksPermission.create(user_id, actions)
    end
    find_users_books_permissions
    respond_to do |format|
      format.html { redirect_to books_settings_path }
      format.js
    end
  end

  def destroy
    UserBooksPermission.delete(params[:id])
    find_users_books_permissions
    respond_to do |format|
      format.html { redirect_to books_settings_path }
      format.js
    end
  end

  private
    def find_users_books_permissions
      @users_books_permissions = UserBooksPermission.all
    end
end
