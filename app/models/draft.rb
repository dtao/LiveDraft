class Draft
  include DataMapper::Resource

  has n, :versions, "DraftVersion"
  has n, :comments
  has 1, :latest_version, "DraftVersion", :order => [:id.desc]

  property :id,         Serial
  property :token,      String, :unique_index => true
  property :email,      String, :index => true
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :email

  before :create do
    self.token ||= Randy.string(8)
  end

  def title
    self.latest_version.try(:title)
  end
end
