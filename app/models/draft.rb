class Draft
  include DataMapper::Resource

  FORMATS = ["markdown", "haml", "html"].freeze
  STYLESHEET_FORMATS = ["css", "sass"].freeze

  belongs_to :user
  has n, :versions, "DraftVersion"
  has n, :stylesheets, "DraftStylesheet"
  has 1, :preview, "DraftPreview", :parent_key => :token, :child_key => :token
  has n, :comments
  has 1, :latest_version, "DraftVersion", :order => [:id.desc]
  has 1, :latest_stylesheet, "DraftStylesheet", :order => [:id.desc]

  property :id,           Serial
  property :token,        String,  :unique_index => true
  property :user_id,      Integer, :index => true
  property :published_at, DateTime
  property :created_at,   DateTime
  property :updated_at,   DateTime

  before :create do
    self.token ||= Randy.string(8)
  end

  def path
    self.title ? "/#{self.token}/#{self.title.parameterize}" : "/#{self.token}"
  end

  def title
    self.latest_version.try(:title)
  end

  def format
    self.latest_version.try(:format)
  end

  def public?
    !!self.published_at
  end

  def self.latest(limit=20)
    all(:limit => limit, :order => [:id.desc])
  end

  def self.published
    all(:published_at.not => nil)
  end
end
