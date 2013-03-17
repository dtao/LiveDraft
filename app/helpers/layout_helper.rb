LiveDraft.helpers do
  def partial(name, locals={}, options={})
    render_partial(:"partials/#{name}", options.merge(:locals => locals))
  end

  def basic_partial(name, value)
    partial(name, name => value)
  end

  def tabs
    partial(:tabs)
  end

  def editor
    partial(:editor)
  end

  def preview_frame
    "<iframe src='/preview/#{@draft.token}'></iframe>" unless @draft.nil?
  end

  def drafts
    partial(:drafts)
  end

  def draft_list(drafts)
    partial(:draft_list, :drafts => drafts)
  end

  def toolbar
    partial(:toolbar)
  end

  def comments
    partial(:comments) unless @draft.nil?
  end

  def single_comment(comment)
    basic_partial(:comment, comment)
  end
end
