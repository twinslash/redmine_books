class BooksController < ApplicationController
  unloadable
  before_filter :check_permission, only: [:new, :create, :edit, :update, :take, :give, :destroy]
  before_filter :assembly_photo_path, only: [:upload_photo, :delete_photo]
  before_filter :delete_empty_book_files, only: [:create, :update]

  def index
    scope = Book.scoped
    @books_count = scope.count
    @limit = per_page_option
    @books_pages = Paginator.new(self, @books_count, @limit, params[:page])
    @offset = @books_pages.current.offset
    @books = scope.scoped limit: @limit, offset: @offset
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:notice] = l(:notice_book_saved)
      redirect_to book_path @book
    else
      render action: :new
    end
  end

  def update
    if @book.update_attributes(params[:book])
      flash[:notice] = l(:notice_book_updated)
      redirect_to book_path @book
    else
      render action: :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:notice] = l('notice_book_deleting', title: @book.title)
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
    @book_record = BookRecord.new(user_id: User.current.id, book_id: params[:id], taken_at: Date.today)
    @book.user = User.current
    if @book_record.save
      flash[:notice] = l(:notice_book_taken, title: @book.title)
      @book.save
    else
      flash[:error] = l(:error_book_taking, title: @book.title)
    end
    respond_to do |format|
      format.html { redirect_to book_path @book }
      format.js { render 'update_book_on_index' }
    end
  end

  def give
    @book.status = :free
    @book_record = BookRecord.where(user_id: User.current.id, book_id: params[:id], returned_at: nil).last_by_taken_at
    @book_record.returned_at = Date.today
    @book.user = nil
    if @book_record.save
      flash[:notice] = l(:notice_book_returned, title: @book.title)
      @book.save
    else
      flash[:error] = l(:error_book_returning, title: @book.title)
    end
    respond_to do |format|
      format.html { redirect_to book_path @book }
      format.js { render 'update_book_on_index' }
    end
  end

  def load_history
    @book = Book.find(params[:id])
    @book_records = @book.book_records
    respond_to do |format|
      format.js
    end
  end

  private
    def check_permission
      action = params[:action]
      @book = Book.find(params[:id]) if params[:id]
      @book ||= Book.new
      if User.current.allowed_books_to? action, @book
        true
      else
        deny_access
      end
    end

    def assembly_photo_path
      @photo_path = Rails.root.to_path + "/public/tmp/" + params[:photo_name].to_s.split('/').join('_')
    end

    def delete_empty_book_files
      params[:book][:book_files_attributes].select! do |k, v|
        v.is_a?(Hash) && v[:file].present?
      end
    end
end
