LiveDraft.helpers do
  def session_panel
    if logged_in?
      render_partial(:session)
    else
      render_partial(:login)
    end
  end
end
