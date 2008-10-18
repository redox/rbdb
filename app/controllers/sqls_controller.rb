class SqlsController < ApplicationController
  before_filter :select_db
  before_filter :select_sql
  
  # GET /sqls
  # GET /sqls.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sqls }
    end
  end

  # GET /sqls/1
  # GET /sqls/1.xml
  def show
    raise ActiveRecord::RecordNotFound if @sql.nil?
    @sql.limit = params[:per_page]
    page = params[:page].nil? ? 1 : params[:page].to_i
    page = 1 if page < 0
    @sql.offset = @sql.limit * (page - 1)

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
        store_sql(@sql)
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
    respond_to do |format|
      if @sql.update_attributes(params[:sql])
        flash[:notice] = 'Sql was successfully updated.'
        update_sql(@sql)
        format.html { redirect_to [@datab, @sql] }
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
  
  private
  def select_sql
    @sql = @sqls.detect { |s| s.id == params[:id].to_i }
  end
end
