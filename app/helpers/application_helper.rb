# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def date_ago(d)
    s = d.to_s(:db) rescue d.to_s
    content_tag 'span', :title => s do
      at = d.is_a?(DateTime) ? (' at %d:%d' % [d.hour, d.min]) : ''
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
  
  def analyze_value value
    if value =~ /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)/i
      return link_to(image_tag("email_go.png"), "mailto:#{value}",
        :title => "send an email to #{value}")
    end
    if value =~ /^(http:\/\/)|(www\.).*/
      return link_to(image_tag('link_go.png', :style => 'display:inline'), value,
        :title => "visit #{value}", :target => '_blank')
    end
    return nil
  end

  def string value
    options = {:title => value}
    options[:class] = 'null' if value.blank?  
    content_tag :span, options do
      (value.blank?) ? (value.nil?) ? 'NULL' : 'EMPTY' : truncate(value, 20)
    end
    
  end
  
  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys
    if object = options.delete(:object)
      objects = [object].flatten
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      options[:object_name] ||= params.first
      options[:header_message] = "#{pluralize(count, 'error')} prohibited this #{options[:object_name].to_s.gsub('_', ' ')} from being saved" unless options.include?(:header_message)
      options[:message] ||= 'There were problems with the following fields:' unless options.include?(:message)
      error_messages = objects.sum do |object|
        object.errors.map do |attribute, message|
          content_tag(:li, message)
        end
      end.join
      contents = ''
      contents << content_tag(options[:header_tag] || :h2, options[:header_message]) unless options[:header_message].blank?
      contents << content_tag(:p, options[:message]) unless options[:message].blank?
      contents << content_tag(:ul, error_messages)

      content_tag(:div, contents, html)
    else
      ''
    end
  end

  def logged_in?
    session[:username]
  end
  
end
