module SessionSizedList
    
  def add_to_session list_name, item, limit = 3
    session[list_name] ||= []
    list = session[list_name]
    list.delete item
    list.shift if list.size >= limit
    list << item
  end

end
