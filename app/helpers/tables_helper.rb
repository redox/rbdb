module TablesHelper
  
  def datetime(d)
    content_tag 'span', :title => d.to_s(:db) do
      at = d.is_a?(DateTime) ? (' at %d:%d' % [d.hours, d.min]) : ''
      d = d.to_date
      if d == Date.today
        "Today#{at}"
      elsif d == Date.yesterday
        "Yesterday#{at}"
      else
        time_ago_in_words(d) + ' ago'
      end
    end
  end
  
  def yes_no(d)
    d == true ? 'Yes' : 'No'
  end
  
end
