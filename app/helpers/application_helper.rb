module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
  
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      space_after_headers: true, 
      fenced_code_blocks: true
    }

    extensions = {
      no_intra_emphasis:   true,
      tables: true,
      strikethrough: true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

end