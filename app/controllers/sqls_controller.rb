class SqlsController < ApplicationController
  before_filter :select_db
  before_filter :select_sql
  
  layout 'database'
  
  def index
  end

  def show    
    raise ActiveRecord::RecordNotFound if @sql.nil?
    @sql.limit = params[:per_page]
    page = params[:page].nil? ? 1 : params[:page].to_i
    page = 1 if page < 0
    @sql.offset = @sql.limit * (page - 1)
  end

  def new
    @sql = Sql.new
  end

  def edit
    @sql = Sql.find(params[:id])
  end

  def create
    @sql = Sql.new(params[:sql])

    if (@sql.save rescue nil)
      flash[:notice] = 'Sql was successfully created.'
      store_sql(@sql, @datab)
      redirect_to [@datab, @sql]
    else
      render :action => "new"
    end
  end

  def destroy
    remove_from_session :sqls, @sql
    flash[:notice] = "SQL query removed"
    redirect_to datab_sqls_path(@datab)
  end
  # def update
  #   if @sql.update_attributes(params[:sql])
  #     flash[:notice] = 'Sql was successfully updated.'
  #     store_sql(@sql, @datab)
  #     redirect_to [@datab, @sql]
  #   else
  #     render :action => "edit"
  #   end
  # end
  
  private
  def select_sql
    @sql = @sqls.detect { |s| s.id == params[:id].to_i }
  end
end
