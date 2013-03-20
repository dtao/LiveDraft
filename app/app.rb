class LiveDraft < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Sinatra::Glorify

  enable :sessions

  ##
  # You can configure for a specified environment like:
  #
  configure do
    use OmniAuth::Builder do
      provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], { access_type: "online", approval_prompt: "" }
    end

    Tilt.prefer Sinatra::Glorify::Template
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      if !@current_user_cached
        @current_user = User.get(session[:user_id])
        @current_user_cached = true
      end
      @current_user
    end

    def current_user_owns_draft?
      @draft.nil? || (logged_in? && @draft.user == current_user)
    end
  end

  def create_draft_version(draft, attributes={})
    version_attributes = {
      :format  => params["format"],
      :content => params["content"]
    }

    if params["style-content"].present?
      version_attributes.merge!({
        :style_format  => params["style-format"],
        :style_content => params["style-content"]
      })
    end

    if params["script-content"].present?
      version_attributes.merge!({
        :script_format  => params["script-format"],
        :script_content => params["script-content"]
      })
    end

    draft.preview.finalize!(version_attributes.merge(attributes))
  end

  def update_draft_version(version)
    version_attributes = {
      :format         => params["format"],
      :content        => params["content"],
      :style_content  => nil,
      :script_content => nil
    }

    if params["style-content"].present?
      version_attributes.merge!({
        :style_format  => params["style-format"],
        :style_content => params["style-content"]
      })
    end

    if params["script-content"].present?
      version_attributes.merge!({
        :script_format  => params["script-format"],
        :script_content => params["script-content"]
      })
    end

    version.update(version_attributes)
  end

  get "/" do
    render :index
  end

  post "/" do
    Draft.transaction do
      @draft = Draft.create(:user => current_user)
      create_draft_version(@draft, :final => true)
    end
    render(:redirect => @draft.path)
  end

  post "/publish" do
    Draft.transaction do
      @draft = Draft.create(:user => current_user, :published_at => Time.now)
      create_draft_version(@draft, :final => true)
    end
    render(:redirect => @draft.path)
  end

  get "/preview/css/:token" do |token|
    draft = Draft.first(:token => token.chomp(".css"))
    content_type "text/css"
    draft.latest_version.to_css
  end

  get "/preview/js/:token" do |token|
    draft = Draft.first(:token => token.chomp(".js"))
    content_type "text/javascript"
    draft.latest_version.to_js
  end

  get "/preview/:token" do |token|
    @draft = Draft.first(:token => token)

    if request.xhr?
      @draft.preview.to_html
    else
      @preview = @draft.latest_version || @draft.preview
      render :preview, :layout => false
    end
  end

  post "/preview" do
    # TODO: Don't duplicate this logic here. Figure out a way to leverage the same code
    # in DraftVersion#to_html and here.
    case params["format"]
    when "markdown"
      markdown(params["content"], :layout => false)
    when "haml"
      haml(params["content"], :layout => false)
    else
      params["content"]
    end
  end

  post "/comment/:token" do |token|
    email = current_user.try(:email) || params["email"]

    if email.blank?
      flash[:notice] = "You must supply an e-mail address."
      halt redirect("/#{token}")
    end

    if !logged_in? && User.first(:email => email)
      flash[:notice] = "A user with that e-mail address exists (log in to comment)."
      halt redirect("/#{token}")
    end

    @draft = Draft.first(:token => token)
    comment = @draft.comments.create(:email => email, :content => params["content"])

    Pusher.trigger_async(@draft.token, "comment", {
      :html => single_comment(comment)
    })

    redirect(@draft.path)
  end

  post "/publish/:token" do |token|
    draft = Draft.first(:token => token)
    draft.update(:published_at => Time.now)
    render(:redirect => draft.path)
  end

  post "/unpublish/:token" do |token|
    draft = Draft.first(:token => token)
    draft.update(:published_at => nil)
    render(:redirect => draft.path)
  end

  post "/preview/:token" do |token|
    draft = Draft.first(:token => token)
    preview = draft.preview
    update_draft_version(preview)
    Pusher.trigger_async(token, "refresh", {})
  end

  get "/logout" do
    session.delete(:user_id)
    redirect(request.referrer || "/")
  end

  get "/auth/google_oauth2/callback" do
    user_info = request.env["omniauth.auth"]["info"]

    user = User.first(:email => user_info["email"]) || User.create({
      :email => user_info["email"],
      :name  => user_info["name"]
    })

    session[:user_id] = user.id

    redirect(request["omniauth.origin"] || "/")
  end

  get %r{/([^/]*)(?:/.*)?} do |token|
    @draft   = Draft.first(:token => token)
    @version = @draft.latest_version
    render :index
  end

  post %r{/([^/]*)(?:/.*)?} do |token|
    puts "\n\n\nParams: #{params.inspect}\n\n\n"

    @draft = Draft.first(:token => token)
    halt render(:error => "You're not allowed to edit this draft!") if !current_user_owns_draft?
    @version = create_draft_version(@draft)
    render(:redirect => @draft.path)
  end
end
