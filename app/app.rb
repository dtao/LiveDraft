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
      provider :google_oauth2, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, { access_type: "online", approval_prompt: "" }
    end

    Tilt.prefer Sinatra::Glorify::Template
  end

  helpers do
    def logged_in?
      !!session[:email]
    end

    def current_user
      @current_user ||= session[:email]
    end

    def current_user_owns_draft?
      @draft.nil? || @draft.email == current_user
    end
  end

  get "/" do
    render :index
  end

  post "/" do
    Draft.transaction do
      @draft = Draft.create(:email => current_user)
      @version = @draft.versions.create(:content => params["content"])
    end
    render(:redirect => "/#{@draft.token}")
  end

  post "/preview" do
    markdown(params["content"])
  end

  post "/comments/:token" do |token|
    @draft = Draft.first(:token => token)
    @draft.comments.create(:email => params["email"], :content => params["content"])
    redirect("/#{token}")
  end

  get "/logout" do
    session.delete(:email)
    redirect("/")
  end

  get "/auth/google_oauth2/callback" do
    session[:email] = request.env["omniauth.auth"]["info"]["email"]
    redirect("/")
  end

  get "/:token" do |token|
    @draft = Draft.first(:token => token)
    @version = @draft.latest_version
    render :index
  end

  post "/:token" do |token|
    @draft = Draft.first(:token => token)
    halt render(:error => "You're not allowed to edit this draft!") if !current_user_owns_draft?
    @version = @draft.versions.create(:content => params["content"])
    render(:redirect => "/#{@draft.token}")
  end
end
