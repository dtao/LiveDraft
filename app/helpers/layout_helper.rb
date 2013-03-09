LiveDraft.helpers do
  alias_method :render_partial_orig, :render_partial
  def render_partial(name, options={})
    render_partial_orig(:"partials/#{name}", options)
  end

  def tabs
    render_partial(:tabs)
  end

  def editor
    render_partial(:editor)
  end

  def drafts
    render_partial(:drafts, :locals => {
      :drafts => Draft.all(:email => current_user, :order => [:id.desc])
    })
  end

  def toolbar
    render_partial(:toolbar)
  end
end
