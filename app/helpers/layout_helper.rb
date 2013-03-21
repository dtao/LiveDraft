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

  def editors
    partial(:editors)
  end

  def editor(version, type, visible=true)
    options = editor_options(type)

    partial(:editor, {
      :type    => type,
      :name    => options[:format],
      :options => options[:options],
      :mode    => version.try(options[:format]) || options[:default],
      :content => version.try(options[:content]),
      :style   => visible ? nil : "display: none;",
      :tab_attributes => {
        :class => ["switch", visible ? "selected" : nil].compact.join(" "),
        :"data-reveal" => "#draft-#{type}",
        :"data-hide" => ".editor"
      }
    })
  end

  def preview_frame
    "<iframe src='/latest/#{@draft.token}'></iframe>" unless @draft.nil?
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

  protected

  def editor_options(type)
    if type == :content
      {
        :content => :content,
        :format  => :format,
        :options => Draft::FORMATS,
        :default => Draft::DEFAULT_FORMAT
      }
    else
      type_const = type.to_s.upcase

      {
        :content => :"#{type}_content",
        :format  => :"#{type}_format",
        :options => Draft.const_get("#{type_const}_FORMATS"),
        :default => Draft.const_get("DEFAULT_#{type_const}_FORMAT")
      }
    end
  end
end
