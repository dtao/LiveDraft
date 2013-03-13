class DraftPreview
  include DataMapper::Resource

  belongs_to :draft, :parent_key => :token, :child_key => :token

  property :id,         Serial
  property :token,      String, :unique_index => true
  property :content,    Text
  property :created_at, DateTime
  property :updated_at, DateTime
end
