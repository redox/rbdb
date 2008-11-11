class RelationsController < ApplicationController
  before_filter :select_db
  before_filter :select_table, :only => [:show, :graph]
  
  layout 'table'

  def show
  end
  
  def graph
    format = nil
    respond_to do |f|
      f.svg { format = 'svg' }
      f.png { format = 'png' }
      f.pdf { format = 'pdf' }
    end
    raise ArgumentError if format.nil?
    send_data(Relation.dot(format, @table, @datab), :type => params[:format],
      :disposition => "inline")
  end

end
