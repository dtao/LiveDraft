LiveDraft.helpers do
  def empty_link(text, attributes={})
    link_to(text, "javascript:void(0);", attributes)
  end
end
