LiveDraft.helpers do
  def gravatar(email, options={})
    email = email.strip.downcase
    hash  = Digest::MD5.hexdigest(email)
    type  = options[:type] || "identicon"
    size  = options[:size] || 50
    image_tag("http://www.gravatar.com/avatar/#{hash}?d=#{type}&s=#{size}", :alt => email)
  end
end
