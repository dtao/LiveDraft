class Comment
  include DataMapper::Resource

  belongs_to :draft
  belongs_to :user, :parent_key => :email, :child_key => :email

  property :id,         Serial
  property :draft_id,   Integer, :index => true, :required => true
  property :email,      String,  :index => true, :required => true
  property :content,    Text,    :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :email
  validates_presence_of :content
end
