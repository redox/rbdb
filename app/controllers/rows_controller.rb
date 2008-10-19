class RowsController < ApplicationController
  
  before_filter :select_db
  before_filter :select_table
  before_filter :nullify_row_fields, :only => [:update, :create]
  before_filter :select_row, :only => [:edit, :update, :destroy]
  
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
    else
      respond_to do |format|
        if @row.update_attributes(params[:row])
          flash[:notice] = 'row was successfully updated.'
          format.html { redirect_to datab_table_row_path(@datab, @table, @row) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @row.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  # GET /rows/new
  # GET /rows/new.xml
  def new
    @row = @table.ar_class.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @row }
    end
  end

  # GET /rows/1/edit
  def edit
  end

  # POST /rows
  # POST /rows.xml
  def create
    @row = @table.ar_class.new(params[:row])
    
    respond_to do |format|
      begin
        @row.save
      rescue StandardError => e
        @row.errors.add :id, e
      end
      if !@row.new_record?
        flash[:notice] = 'row was successfully created.'
        format.html { redirect_to datab_table_row_path(@datab, @table, @row) }
        format.xml  { render :xml => @row, :status => :created, :location => @row }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @row.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rows/1
  # DELETE /rows/1.xml
  def destroy
    @row.destroy

    respond_to do |format|
      flash[:notice] = 'rows was successfully destroyed.'
      format.html { redirect_to datab_table_path(@datab, @table) }
      format.xml  { head :ok }
    end
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
