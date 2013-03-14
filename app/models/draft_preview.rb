# TODO: Consolidate this class and DraftVersion (think of a better design).

class DraftPreview
  include DataMapper::Resource
  include ToHtml

  belongs_to :draft, :parent_key => :token, :child_key => :token

  property :id,         Serial
  property :token,      String, :unique_index => true
  property :format,     String, :default => "markdown"
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_within :format, :set => Draft::FORMATS
end
