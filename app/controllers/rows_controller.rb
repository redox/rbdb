class RowsController < ApplicationController
  
  before_filter :select_db
  before_filter :select_table
  before_filter :nullify_row_fields, :only => [:update, :create]
  before_filter :select_row, :only => [:edit, :update, :destroy]
  
  layout 'table'
  
  def index
    if params[:field].nil? or params[:value].nil?
      redirect_to datab_table_path(@datab, @table)
      return
    end

    rows = @table.ar_class.all :conditions => {params[:field] => params[:value]}
    @rows = WillPaginate::Collection.create(1, rows.size) do |pager|
      pager.replace rows
      pager.total_entries = rows.size
    end
  end
  
  def show
    @rows = WillPaginate::Collection.create(1, 1) do |pager|
      pager.replace [@table.ar_class.find(params[:id])]
      pager.total_entries = 1
    end
  end
  
  def update
    if request.xhr?
      if @row.update_attributes params[:row]
        render :json => @row
      else
        render :json => @table.errors, :status => :unprocessable_entity
      end
      return
    end

    if @row.update_attributes(params[:row])
      flash[:notice] = 'row was successfully updated.'
      redirect_to datab_table_row_path(@datab, @table, @row)
    else
      render :action => "edit"
    end
  end
  
  def new
    @row = @table.ar_class.new
  end

  def edit
  end

  def create
    @row = @table.ar_class.new(params[:row])
    
    begin
      @row.save
    rescue StandardError => e
      @row.errors.add :id, e
    end
    if !@row.new_record?
      flash[:notice] = 'row was successfully created.'
      redirect_to datab_table_row_path(@datab, @table, @row)
    else
      render :action => "new"
    end
  end

  def destroy
    @row.destroy

    flash[:notice] = 'rows was successfully destroyed.'
    redirect_to datab_table_path(@datab, @table)
  end
  
  private
  def nullify_row_fields
    params[:null].each do |k,v|
      next if v != "1"
      params[:row][k] = nil
    end if params[:null]
  end
  
  def select_row
    @row = @table.ar_class.find(params[:id])
  end
end
