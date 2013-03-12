class User
  include DataMapper::Resource

  has n, :drafts
  has n, :comments, :parent_key => :email, :child_key => :email

  property :id,    Serial
  property :email, String, :unique_index => true
  property :name,  String

  validates_presence_of :email
  validates_presence_of :name
end
