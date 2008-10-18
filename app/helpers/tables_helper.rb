module TablesHelper

  def most_likely_name r
    if r.respond_to? :name
      r.name
    else
      r.attributes.find {|c, v| v.is_a? String }[1]
    end
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
