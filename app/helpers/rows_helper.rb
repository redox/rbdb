module RowsHelper
  
  def field_for(attribute, column, form, options = {})
    case column.type
    when :datetime, :time
      form.calendar_date_select attribute, :time => true
    when :date
      form.calendar_date_select attribute
    when :boolean
      form.check_box attribute, options
    else
      if column.text? and column.limit.nil?
        form.text_area attribute, options
      else
        form.text_field attribute, options
      end
    end
  end
  
end
