class DraftVersion
  include DataMapper::Resource

  belongs_to :draft

  property :id,         Serial
  property :draft_id,   Integer
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime
end
