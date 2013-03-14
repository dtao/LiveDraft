module ToHtml
  def to_html
    case self.format
    when "markdown"
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(self.content)
    when "haml"
       Haml::Engine.new(self.content).render
    when "html"
      self.content
    end
  end
end
