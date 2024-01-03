module MarkdownHelper
  def renderHtml(markdown)
    Markdown.new(markdown.to_s).to_html
  end
end
