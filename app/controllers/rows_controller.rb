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
    if rows.empty?
      @rows = []
    else
      @rows = WillPaginate::Collection.create(1, rows.size) do |pager|
        pager.replace rows
        pager.total_entries = rows.size
      end
    end
  end
  
  def show
    @rows = WillPaginate::Collection.create(1, 1) do |pager|
      pager.replace [@table.ar_class.find(params[:id])]
      pager.total_entries = 1
    end
  end
  
  #TODO do something prettier about the id update, maybe an alias_method on update_attributes˝
  def update
    if request.xhr?
      if params[:row].has_key? :id
        ActiveRecord::Base.connection.execute("UPDATE #{@table.name} SET id=#{params[:row][:id].to_i} WHERE id=#{@row.id}")
        render :json => @table.ar_class.find(params[:row][:id])
        return
      end
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
    render :nothing => true
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
