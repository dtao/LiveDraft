class DraftStylesheet
  include DataMapper::Resource

  belongs_to :draft

  property :id,         Serial
  property :draft_id,   Integer, :index => true, :required => true
  property :format,     String,  :default => "css"
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :content
  validates_within :format, :set => Draft::STYLESHEET_FORMATS
end
