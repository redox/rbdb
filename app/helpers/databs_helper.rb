module DatabsHelper
  
  def table_icon table
    icon = if table.view?
      'view'
    else
      'table'
    end
    image_tag "#{icon}.png"
  end
  
end
