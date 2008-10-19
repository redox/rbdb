class TablesController < ApplicationController
  before_filter :select_db
  before_filter :select_table, :only => [:show]
  
  # GET /tables
  # GET /tables.xml
  def index
    @tables = Table.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tables }
    end
  end

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
    session[:structure] = session[:structure] || (!session[:structure] && !session[:browse])
    if (session[:browse])
      @rows = @table.ar_class.paginate :page => params[:page], :per_page => 30, :order => params[:order]
    end
    @columns = @table.columns

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @table }
    end
  end

  # GET /tables/new
  # GET /tables/new.xml
  def new
    @table = Table.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @table }
    end
  end

  # GET /tables/1/edit
  def edit
    @table = Table.find(params[:id])
  end

  # POST /tables
  # POST /tables.xml
  def create
    @table = Table.new(params[:table])

    respond_to do |format|
      if @table.save
        flash[:notice] = 'Table was successfully created.'
        format.html { redirect_to(@table) }
        format.xml  { render :xml => @table, :status => :created, :location => @table }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tables/1
  # PUT /tables/1.xml
  def update
    @table = Table.find(params[:id])

    respond_to do |format|
      if @table.update_attributes(params[:table])
        flash[:notice] = 'Table was successfully updated.'
        format.html { redirect_to(@table) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.xml
  def destroy
    @table = Table.find(params[:id])
    @table.destroy

    respond_to do |format|
      format.html { redirect_to(tables_url) }
      format.xml  { head :ok }
    end
  end
    
end
