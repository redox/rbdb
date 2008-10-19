class RowsController < ApplicationController
  
  before_filter :select_db
  before_filter :select_table
  
  def show
    @row = WillPaginate::Collection.create(1, 1) do |pager|
      pager.replace [@table.ar_class.find(params[:id])]
      pager.total_entries = 1
    end
  end
  
  def update
    row = @table.ar_class.find params[:id]
    if row.update_attributes params[:row]
      render :json => row
    else
      render :json => @table.errors, :status => :unprocessable_entity
    end
  end
  
end
