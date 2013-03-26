class DraftVersion
  include DataMapper::Resource

  belongs_to :draft

  property :id,             Serial
  property :draft_id,       Integer, :index => true, :required => true
  property :title,          String
  property :format,         String,  :default => "markdown"
  property :content,        Text,    :default => ""
  property :style_format,   String,  :default => "sass"
  property :style_content,  Text
  property :script_format,  String,  :default => "coffeescript"
  property :script_content, Text
  property :final,          Boolean, :default => false
  property :created_at,     DateTime
  property :updated_at,     DateTime

  validates_within :format,        :set => Draft::FORMATS
  validates_within :style_format,  :set => Draft::STYLE_FORMATS
  validates_within :script_format, :set => Draft::SCRIPT_FORMATS

  before :save do
    html = Nokogiri::HTML.parse(self.to_html)

    # If the first element in the document is a heading of some kind, snag that as the title.
    first_element = html.css("body").children.first
    if first_element.try(:name) =~ /^h\d+$/i
      self.title = first_element.text
    else
      self.title = nil
    end
  end

  def self.final
    all(:final => true)
  end

  # TODO: Either work out a smart way to declare "this method must be called in a transaction" or
  # hack DM to allow nested transactions (maybe just by requiring the "dm-nested-transactions"
  # gem?).
  def finalize!(attributes={})
    # self.transaction do
      # Create a new preview version based on this one.
      self.draft.versions.create({
        :format         => self.format,
        :content        => self.content,
        :style_format   => self.style_format,
        :style_content  => self.style_content,
        :script_format  => self.script_format,
        :script_content => self.script_content
      })

      # Promote this version as final.
      self.update(attributes.merge(:final => true))
    # end
  end

  def has_style?
    !!self.style_content
  end

  def has_script?
    !!self.script_content
  end

  def to_html
    html = ""

    begin
      case self.format
      when "markdown"
        html = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(self.content || "")
      when "haml"
        html = Haml::Engine.new(self.content).render
      when "html"
        html = self.content
      end

      # Validate CSS and JS, just to catch any errors so that we can display them.
      self.to_css
      self.to_js

    rescue => ex
      html << "<div id='livedraft-error'>#{ex.message}</div>"
    end

    html
  end

  def to_css
    case self.style_format
    when "sass"
      Sass::Engine.new(self.style_content, :syntax => :sass).render
    else
      self.style_content
    end
  end

  def to_js
    case self.script_format
    when "coffeescript"
      CoffeeScript.compile(self.script_content)
    else
      self.script_content
    end
  end
end
