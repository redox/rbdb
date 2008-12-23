module TablesHelper

  def most_likely_name r
    [:name, :login, :email].each do |m|
      return r.send(m) if r.respond_to?(m)
    end
    return ((r.attributes.find {|c, v| v.is_a? String}[1] rescue r.id) or r.id)
  end

  def editable_field row, column, content
    case column.type
    when :datetime, :time, :date
      _erbout = ''
      field_name = "field_#{column.name}_#{row.id}"
      form_name = "edit_#{column.name}_#{row.id}"
              p "nil == #{content}"
     
        content_tag :span, :id => field_name,
          :onclick => "$('#{form_name}').show();$('#{field_name}').hide();" do
           if content.is_a? String
             _erbout.concat content
           else
             _erbout.concat date_ago(content)
           end
        end       
     
      remote_form_for(row, :url => datab_table_row_path(@datab, @table, row),
        :html => {:style => 'display: none', :id => form_name},
        :complete => "$('#{form_name}').hide();$('#{field_name}').show();$('#{field_name}').update(request.responseText.evalJSON()['#{column.name}'])") do
        fields_for 'row', row do |f|
          _erbout.concat f.calendar_date_select(column.name)
          _erbout.concat f.submit('Save')
          cancel_link = link_to_function('cancel') do |page|
            page[form_name].hide
            page[field_name].show
          end
          _erbout.concat cancel_link
        end
      end
    else
      edit_in_place row, column.name, :url => datab_table_row_path(@datab, @table, row[:id]),
        :content => content, :dom_id => "row_#{row[:id]}"
    end
  end
  
  def number_delimited num
    content_tag :span, :title => num do
      number_with_delimiter num
    end
  end
  
end

