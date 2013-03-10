LiveDraft.helpers do
  def smart_date_format(date)
    if today?(date)
      date.strftime("%l:%M %P")
    elsif date.year == Date.today.year
      date.strftime("%B %e")
    else
      date.strftime("%b %e, %Y")
    end
  end

  def today?(date)
    today = Date.today
    [:day, :month, :year].all? { |m| today.send(m) == date.send(m) }
  end
end
