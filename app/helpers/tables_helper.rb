module TablesHelper

  def most_likely_name r
    [:name, :login, :email].each do |m|
      return r.send(m) if r.respond_to?(m)
    end
    return (r.attributes.find {|c, v| v.is_a? String}[1] rescue r.id)
  end

  def editable_field row, column, content
    edit_in_place row, column.name, :url => datab_table_row_path(@datab, @table, row[:id]), :content => content, :dom_id => "row_#{row[:id]}"
  end
  
  def number_delimited num
    content_tag :span, :title => num do
      number_with_delimiter num
    end
  end
  
end

