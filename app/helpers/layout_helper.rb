LiveDraft.helpers do
  def partial(name, options={})
    render_partial(:"partials/#{name}", options)
  end

  def tabs
    partial(:tabs)
  end

  def editor
    partial(:editor)
  end

  def drafts
    partial(:drafts, :locals => {
      :drafts => Draft.all(:user => current_user, :limit => 20, :order => [:id.desc])
    })
  end

  def toolbar
    partial(:toolbar)
  end

  def comments
    partial(:comments) unless @draft.nil?
  end
end
