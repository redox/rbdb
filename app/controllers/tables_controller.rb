class TablesController < ApplicationController
  before_filter :select_db
  before_filter :select_table, :only => [:show]
  
  layout 'table'
  
  # GET /tables/1
  # GET /tables/1.xml
  def show
    if params.has_key? :structure
      session[:browse] = nil
      params[:structure] = nil
      session[:structure] = true
    end
    if params.has_key? :browse
      session[:structure] = nil
      params[:browse] = nil
      session[:browse] = true
    end
    if params.has_key? :per_page
      session[:per_page] = params[:per_page].to_i
    end
    session[:per_page] ||= 30
    session[:structure] = session[:structure] || (!session[:structure] && !session[:browse])
    @page = (params.has_key? :page) ? params[:page].to_i : 1
    @order = params[:order]
    if session[:browse]
      @rows = @table.ar_class.paginate :page => params[:page], :per_page => session[:per_page],
        :order => params[:order]
    end
    @columns = @table.columns
    store_table(@table)
    @relations = Relation.has_many(@table, @datab)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @table }
    end
  end

  private
  MAX_STORED_TABLES = 3
  def store_table(table)
    add_to_session :last_tables, {:name => table.name, :db => @datab.name}, MAX_STORED_TABLES
  end
    
end
