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
      @draft.nil? || @draft.user == current_user
    end
  end

  get "/" do
    render :index
  end

  post "/" do
    Draft.transaction do
      @draft = Draft.create(:user => current_user)
      @version = @draft.versions.create(:content => params["content"])
    end
    render(:redirect => "/#{@draft.token}")
  end

  post "/preview" do
    markdown(params["content"])
  end

  post "/comments/:token" do |token|
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
      :html => render_comment(comment)
    })

    redirect("/#{token}")
  end

  get "/logout" do
    session.delete(:user_id)
    redirect("/")
  end

  get "/auth/google_oauth2/callback" do
    user_info = request.env["omniauth.auth"]["info"]

    user = User.first(:email => user_info["email"]) || User.create({
      :email => user_info["email"],
      :name  => user_info["name"]
    })

    session[:user_id] = user.id

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
