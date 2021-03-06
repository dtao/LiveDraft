class Draft
  include DataMapper::Resource

  FORMATS               = ["haml", "html", "markdown"].freeze
  STYLE_FORMATS         = ["css", "sass"].freeze
  SCRIPT_FORMATS        = ["coffeescript", "javascript"].freeze
  DEFAULT_FORMAT        = "markdown".freeze
  DEFAULT_STYLE_FORMAT  = "sass".freeze
  DEFAULT_SCRIPT_FORMAT = "coffeescript".freeze

  belongs_to :user
  has n, :versions, "DraftVersion"
  has n, :comments
  has 1, :latest_version, "DraftVersion", :final => true, :order => [:id.desc]
  has 1, :preview, "DraftVersion", :final => false, :order => [:id.desc]

  property :id,           Serial
  property :token,        String,  :unique_index => true
  property :user_id,      Integer, :index => true
  property :published_at, DateTime
  property :created_at,   DateTime
  property :updated_at,   DateTime

  before :create do
    self.token ||= Randy.string(8)
  end

  after :create do
    self.versions.create
  end

  def self.latest(limit=20)
    all(:limit => limit, :order => [:id.desc])
  end

  def self.published
    all(:published_at.not => nil)
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

  def started?
    !!self.latest_version
  end

  def to_s
    self.title || self.token
  end
end
