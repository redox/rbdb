class RowsController < ApplicationController
  
  before_filter :select_db
  before_filter :select_table
  
  def update
    row = @table.ar_class.find params[:id]
    if row.update_attributes params[:row]
      render :json => row
    else
      render :json => @table.errors, :status => :unprocessable_entity
    end
  end
  
end
