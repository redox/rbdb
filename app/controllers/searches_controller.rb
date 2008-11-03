class SearchesController < ApplicationController
  before_filter :select_db
  before_filter :select_table
  before_filter :remove_blank_fields, :only => [:create, :update]
  
  # GET /searches/1
  # GET /searches/1.xml
  def show
    @conditions = session[:searches][params[:id].to_i][:conditions]

    if params.has_key? :per_page
      session[:per_page] = params[:per_page].to_i
    end
    session[:per_page] ||= 30

    @rows = @table.ar_class.paginate(:conditions => @conditions, :page => params[:page],
     :per_page => session[:per_page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @search }
    end
  end

  # GET /searches/new
  # GET /searches/new.xml
  def new
    @search = Search.new(@table)
    @row = @search.row

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @search }
    end
  end

  # GET /searches/1/edit
  def edit
    s = session[:searches][params[:id].to_i]
    @search = Search.new(@table, s[:attributes], s[:modifiers])
    @row = @search.row
  end

  # POST /searches
  # POST /searches.xml
  def create
    @search = Search.new(@table, params[:search], params[:modifiers])

    respond_to do |format|
      if @search.save
        session[:searches] ||= {}
        session[:searches][@search.id] = {
          :conditions => @search.conditions,
          :attributes => @search.row.attributes,
          :modifiers => @search.modifiers
        }
        flash[:notice] = 'Search was successfully created.'
        format.html { redirect_to datab_table_search_path(@datab, @table, @search) }
        format.xml  { render :xml => @search, :status => :created, :location => @search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.xml
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        flash[:notice] = 'Search was successfully updated.'
        format.html { redirect_to(@search) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def remove_blank_fields
    params[:search].each do |k,v|
      next if !v.blank?
      params[:search].delete k
    end
  end
end
