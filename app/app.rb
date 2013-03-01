class LiveDraft < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  ##
  # You can configure for a specified environment like:
  #
  configure do
    use OmniAuth::Builder do
      provider :google_oauth2, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, { access_type: "online", approval_prompt: "" }
    end
  end
  
  get "/" do
    render :index
  end
end
