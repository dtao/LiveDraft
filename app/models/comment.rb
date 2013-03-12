class Comment
  include DataMapper::Resource

  belongs_to :draft

  # For some reason this makes it so that if there isn't a user with this e-mail address,
  # then calling #user returns nil and mysteriously sets email to nil as well.
  # belongs_to :user, :parent_key => :email, :child_key => :email

  property :id,         Serial
  property :draft_id,   Integer, :index => true, :required => true
  property :email,      String,  :index => true, :required => true
  property :content,    Text,    :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :email
  validates_presence_of :content

  def user
    @user ||= User.first(:email => self.email)
  end
end
