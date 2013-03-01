##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  # enable :sessions
  set :session_secret, ENV["SESSION_SECRET"]
end

# Mounts the core application for this project
Padrino.mount("LiveDraft").to("/")
