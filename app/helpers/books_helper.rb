module BooksHelper
  def photo_for(book, style = :medium, options = {})
    height = options[:height] || options[:width]
    width = options[:width] || options[:height]
    options.delete(:width)
    options.delete(:height)
    options[:wrapper] ||= {}
    photo = "<div style='#{options[:wrapper][:style]};display:table-cell;vertical-align:middle;width:#{width};height:#{height};' id='#{options[:wrapper][:id]}' class='#{options[:wrapper][:class]}'>"
    options.delete(:wrapper)
    options[:style] = (options[:style] || "") + "display:block;margin:auto;"
    if book.photo.present?
      options[:style] += "max-width:#{width};max-height:#{height};"
      url = book.photo.url(style)
    else
      options[:style] += "max-width:100px;max-height:100px;"
      url = '/plugin_assets/redmine_books/images/image_missing_icon.png'
    end
    photo << image_tag(url, options)
    photo << '</div>'
    photo.html_safe
  end

  def link_to_action(action, book, options = {})
    if User.current.allowed_books_to? action, book
      case action
      when "delete"
        link_to l("principal_books_action_#{action}"), book_path(book), { method: :delete, data: { confirm: l(:text_are_you_sure) }, class: 'icon icon-del' }.merge(options)
      else
        link_to l("principal_books_action_#{action}"), send("#{action}_book_path", book), { class: "icon icon-#{action}" }.merge(options)
      end
    end
  end

  def link_to_actions(actions, book, options = {})
    links = ""
    actions.each do |action|
      links += link_to_action(action, book, options).to_s
    end
    links.html_safe
  end
end
