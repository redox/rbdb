class SqlsController < ApplicationController
  before_filter :select_db
  
  # GET /sqls
  # GET /sqls.xml
  def index
    @sqls = []
    session[:sqls].each do |s|
      @sqls << Sql.new(s)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sqls }
    end
  end

  # GET /sqls/1
  # GET /sqls/1.xml
  def show
    @sql = Sql.new(session[:sqls][params[:id]]) rescue nil
    raise ActiveRecord::RecordNotFound if @sql.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sql }
    end
  end

  # GET /sqls/new
  # GET /sqls/new.xml
  def new
    @sql = Sql.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sql }
    end
  end

  # GET /sqls/1/edit
  def edit
    @sql = Sql.find(params[:id])
  end

  # POST /sqls
  # POST /sqls.xml
  def create
    @sql = Sql.new(params[:sql])

    respond_to do |format|
      if @sql.save
        flash[:notice] = 'Sql was successfully created.'
        session[:sqls] ||= {}
        session[:sqls][@sql.id.to_s] = {:body => @sql.body, :id => @sql.id}
        format.html { redirect_to datab_sql_path(@datab, @sql) }
        format.xml  { render :xml => @sql, :status => :created, :location => @sql }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sql.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sqls/1
  # PUT /sqls/1.xml
  def update
    @sql = Sql.find(params[:id])

    respond_to do |format|
      if @sql.update_attributes(params[:sql])
        flash[:notice] = 'Sql was successfully updated.'
        format.html { redirect_to(@sql) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sql.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sqls/1
  # DELETE /sqls/1.xml
  def destroy
    @sql = Sql.find(params[:id])
    @sql.destroy

    respond_to do |format|
      format.html { redirect_to(sqls_url) }
      format.xml  { head :ok }
    end
  end
end
