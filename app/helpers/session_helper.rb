LiveDraft.helpers do
  def session_panel
    if logged_in?
      partial(:session)
    else
      partial(:login)
    end
  end
end
