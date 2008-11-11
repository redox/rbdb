class TablesController < ApplicationController
  before_filter :select_db
  before_filter :select_table, :only => [:show]
  
  layout 'table'
  
  # GET /tables/1
  # GET /tables/1.xml
  def show
    session[:mode] ||= 'structure'
    session[:mode] = params[:mode] if params[:mode]
    session[:per_page] = params[:per_page].to_i if params.has_key? :per_page
    session[:per_page] = 30 if session[:per_page].to_i <= 0
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @order = params[:order]
    if session[:mode] == 'browse'
      @rows = @table.ar_class.paginate :page => @page, :per_page => session[:per_page],
        :order => @order
    else
      @relations = Relation.has_many(@table, @datab)  
    end
    @columns = @table.columns
    store_table(@table)
    respond_to do |format|
      format.html { render :action => session[:mode] }
      format.xml  { render :xml => @table }
    end
  end

  private
  MAX_STORED_TABLES = 3
  def store_table(table)
    add_to_session :last_tables, {:name => table.name, :db => @datab.name}, MAX_STORED_TABLES
  end
    
end
