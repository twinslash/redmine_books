module BooksHelper
  def photo_for book, style = :medium, options = {}
    if book.photo.present?
      image_tag book.photo.url(style), options
    else
      image_tag '/plugin_assets/redmine_books/images/image_missing_icon.jpg', options.merge({ style: (options[:style] || "") + "max-width:100px;max-height:100px;" })
    end
  end
end
