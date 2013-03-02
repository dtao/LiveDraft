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

  def toolbar
    render_partial(:toolbar)
  end
end
