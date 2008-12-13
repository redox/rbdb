module SessionSizedList
    
  def add_to_session list_name, item, limit = 3
    session[list_name] ||= []
    list = session[list_name]
    list.delete item
    if item.has_key? :body
      list.reject! do |it|
        it[:body] == item[:body]
      end
    end
    list.shift if list.size >= limit
    list << item
  end
  
  def remove_from_session list_name, item
    session[list_name] ||= []
    list = session[list_name]
    list.reject! {|it| it[:id] == item.id}
  end

end
