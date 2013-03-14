class DraftVersion
  include DataMapper::Resource
  include ToHtml

  belongs_to :draft

  property :id,         Serial
  property :draft_id,   Integer, :index => true, :required => true
  property :title,      String
  property :format,     String,  :default => "markdown"
  property :content,    Text,    :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :content
  validates_within :format, :set => Draft::FORMATS

  before :create do
    html = Nokogiri::HTML.parse(self.to_html)

    # If the first element in the document is a heading of some kind, snag that as the title.
    first_element = html.css("body").children.first
    if first_element.name =~ /^h\d+$/i
      self.title = first_element.text
    end
  end
end
