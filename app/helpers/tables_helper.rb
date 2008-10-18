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

  def string value
    disp = truncate value, 20
    content_tag 'span', :title => value do
      if value =~ /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
        content_tag 'a', :href => "mailto:#{value}" do
          disp
        end
      elsif value =~ /http:\/\/.*/
        content_tag 'a', :href => value do
          disp
        end
      else
        disp
      end
    end
  end
  
end
