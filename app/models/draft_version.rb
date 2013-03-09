class DraftVersion
  include DataMapper::Resource

  belongs_to :draft, :touch => true

  property :id,         Serial
  property :draft_id,   Integer
  property :title,      String
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime

  before :create do
    mkdn = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    html = Nokogiri::HTML.parse(mkdn.render(self.content))

    # If the first element in the document is a heading of some kind, snag that as the title.
    first_element = html.css("body").children.first
    if first_element.name =~ /^h\d+$/i
      self.title = first_element.text
    end
  end
end
