class BooksController < ApplicationController
  unloadable
  before_filter :check_permission, except: [:index, :upload_photo, :delete_photo, :load_history, :my]
  before_filter :assembly_photo_path, only: [:upload_photo, :delete_photo]
  before_filter :delete_empty_book_files, only: [:create, :update]
  before_filter :store_back_url_in_session, only: [:index, :my]

  def index
    @tags = Book.tag_counts
    @selected_tags = params[:tags]
    @match_all = params[:match_all].present? ? true : false
    tagged_options = @match_all ? { } : { any: true }
    scope = params[:tags].blank? ? Book.scoped : Book.tagged_with(@selected_tags, tagged_options)
    scope = scope.visible unless User.current.admin?
    @books_count = scope.count
    @limit = per_page_option
    @books_pages = Paginator.new(self, @books_count, @limit, params[:page])
    @offset = @books_pages.current.offset
    @books = scope.scoped limit: @limit, offset: @offset
  end

  def show
    @book = Book.find(params[:id])
    @is_visible = @book.visible?
    @user = User.current
    @rate = @book.rate_by User.current
    @rate ||= Rate.new
    @rates = @book.rates_without_dimension.order('updated_at DESC')
  end

  def new
  end

  def edit
  end

  def create
    @book = Book.new(params[:book])
    @book.owner = params[:own_book] ? @user : nil
    if @book.save
      flash[:notice] = l(:notice_book_saved)
      redirect_to book_path @book
    else
      render action: :new
    end
  end

  def update
    @book.owner = params[:own_book] ? @user : nil
    if @book.update_attributes(params[:book])
      flash[:notice] = l(:notice_book_updated)
      redirect_to book_path @book
    else
      render action: :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:notice] = l('notice_book_deleted', title: @book.title)
    else
      flash[:error] = l('error_book_deleting', title: @book.title)
    end

    respond_to do |format|
      format.html { redirect_to books_path }
      format.js
    end
  end

  def upload_photo
    @photo = params[:book][:photo]
    File.open(@photo_path, 'wb') do |f|
      f.write(@photo.tempfile.read)
    end
    render nothing: true
  end

  def delete_photo
    File.delete(@photo_path) if File.file?(@photo_path)
    render nothing: true
  end

  def take
    @book.status = :busy
    @book.save
    if @book.create_current_book_record(user: User.current, taken_at: Date.today)
      flash[:notice] = l(:notice_book_taken, title: @book.title)
    else
      flash[:error] = l(:error_book_taking, title: @book.title)
    end
    respond_to do |format|
      format.html { redirect_to book_path @book }
      format.js { render 'update_book_on_index' }
    end
  end

  def give
    @book.current_book_record.update_attributes(returned_at: Date.today, returned_by: User.current)
    @book.status = :free
    if @book.save
      flash[:notice] = l(:notice_book_returned, title: @book.title)
    else
      flash[:error] = l(:error_book_returning, title: @book.title)
    end
    respond_to do |format|
      format.html { redirect_to book_path @book }
      format.js { render 'update_book_on_index' }
    end
  end

  alias_method :give_instead_user, :give

  def load_history
    @book = Book.find(params[:id])
    @book_records = @book.book_records
    respond_to do |format|
      format.js
    end
  end

  def estimate
    @user = User.current
    @rate = @book.rate(params[:stars].to_i, @user, nil, params[:rate])

    respond_to do |format|
      if @rate.save
        format.js { render 'rates/update_rates' }
      else
        format.js { render 'rates/update_form' }
      end
    end
  end

  def change_visibility
    @book.visibility = (params[:visible].to_s == "true")
    respond_to do |format|
      format.html do
        unless @book.save
          flash[:error] = t('error_can_not_change_visibility')
        end
        redirect_to book_path(@book)
      end
    end
  end

  def my
    @books = User.current.own_books
  end


  private

    def check_permission
      @user ||= User.current
      action = params[:action]
      @book = Book.find(params[:id]) if params[:id]
      @book ||= Book.new
      if @user.allowed_books_to? action, @book
        true
      else
        deny_access
      end
    end

    def assembly_photo_path
      @photo_path = Rails.root.to_path + "/public/tmp/" + params[:photo_name].to_s.split('/').join('_')
    end

    def delete_empty_book_files
      params[:book][:book_files_attributes] && params[:book][:book_files_attributes].select! do |_, v|
        v.is_a?(Hash) && v[:file].present?
      end
    end

    def store_back_url_in_session
      session[:back_url] = url_for(params)
    end
end
